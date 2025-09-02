package messaging

import (
	"context"
	"encoding/json"
	"time"

	"github.com/phuslu/log"
	"github.com/rabbitmq/amqp091-go"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/requests"
	"github.com/bagasunix/ngewarung/internal/usecases"
	"github.com/bagasunix/ngewarung/pkg/env"
)

// EmailConsumer menangani pesan email
type EmailConsumer struct {
	ctx      context.Context
	cfg      *env.Cfg
	logger   *log.Logger
	amqpConn *amqp091.Connection
	usecase  usecases.UserUsecase
	channel  *amqp091.Channel
	stopChan chan struct{}
}

// NewEmailConsumer membuat instance baru EmailConsumer
func NewEmailConsumer(ctx context.Context, cfg *env.Cfg, logger *log.Logger,
	amqpConn *amqp091.Connection, usecase usecases.UserUsecase) *EmailConsumer {

	return &EmailConsumer{
		ctx:      ctx,
		cfg:      cfg,
		logger:   logger,
		amqpConn: amqpConn,
		usecase:  usecase,
		stopChan: make(chan struct{}),
	}
}

// Start menjalankan email consumer
func (ec *EmailConsumer) Start() error {
	ec.logger.Info().Msg("Starting email consumer...")

	ch, err := ec.amqpConn.Channel()
	if err != nil {
		ec.logger.Error().Err(err).Msg("Failed to create channel for email consumer")
		return err
	}
	ec.channel = ch

	// Set prefetch count untuk mengontrol berapa banyak pesan yang diambil sekaligus
	err = ch.Qos(
		1,     // prefetch count
		0,     // prefetch size
		false, // global
	)
	if err != nil {
		ec.logger.Error().Err(err).Msg("Failed to set QoS")
		return err
	}

	// Tidak perlu mendeklarasikan queue lagi, langsung consume dari queue yang sudah ada
	msgs, err := ch.ConsumeWithContext(ec.ctx,
		"email",          // queue name
		"email-consumer", // consumer tag
		false,            // auto-ack (false karena kita akan manual ack)
		false,            // exclusive
		false,            // no-local
		false,            // no-wait
		nil,              // arguments
	)
	if err != nil {
		ec.logger.Error().Err(err).Msg("Failed to register email consumer")
		return err
	}

	// Process messages
	go ec.processMessages(msgs)

	ec.logger.Info().Msg("Email consumer started successfully")
	return nil
}

// Stop menghentikan email consumer
func (ec *EmailConsumer) Stop() error {
	ec.logger.Info().Msg("Stopping email consumer...")
	close(ec.stopChan)
	if ec.channel != nil {
		if err := ec.channel.Close(); err != nil {
			ec.logger.Error().Err(err).Msg("Failed to close channel")
			return err
		}
	}
	ec.logger.Info().Msg("Email consumer stopped successfully")
	return nil
}

// Name mengembalikan nama consumer
func (ec *EmailConsumer) Name() string {
	return "email-consumer"
}

// handleMessage menangani pesan individual
func (ec *EmailConsumer) handleMessage(msg *amqp091.Delivery) {
	startTime := time.Now()

	defer func() {
		if r := recover(); r != nil {
			ec.logger.Error().Interface("recover", r).Msg("Recovered from panic in email handler")
			// Jangan lupa untuk meng-ack/nack meskipun ada panic
			msg.Nack(false, true) // Requeue message jika terjadi panic
		}
	}()

	switch msg.RoutingKey {
	case "email.registration":
		ec.logger.Info().Msgf("Received email message: %s", msg.RoutingKey)

		user := new(requests.UserRequest)
		if err := json.Unmarshal(msg.Body, &user); err != nil {
			ec.logger.Error().Err(err).Msg("Failed to unmarshal user registration message")
			msg.Nack(false, true) // Requeue message
			return
		}

		if err := ec.usecase.SendEmailRegistration(ec.ctx, user); err != nil {
			ec.logger.Error().Err(err).Msg("Failed to send registration email")
			msg.Nack(false, true) // Requeue message
			return
		}

		ec.logger.Info().Msgf("Registration email sent to %s in %v", user.Email, time.Since(startTime))
		msg.Ack(false) // Ack message setelah berhasil diproses

	default:
		ec.logger.Warn().Msgf("Unknown routing key: %s", msg.RoutingKey)
		msg.Ack(false) // Ack unknown messages to remove from queue
	}

	// PERHATIAN: JANGAN menutup channel di sini!
	// Channel harus tetap terbuka untuk menerima pesan berikutnya
}
func (ec *EmailConsumer) processMessages(msgs <-chan amqp091.Delivery) {
	ec.logger.Info().Msg("Email consumer started processing messages")

	defer func() {
		if r := recover(); r != nil {
			ec.logger.Error().Interface("recover", r).Msg("Recovered from panic in email processor")
		}
		ec.logger.Info().Msg("Email consumer message processing stopped")
	}()

	for {
		select {
		case <-ec.ctx.Done():
			ec.logger.Info().Msg("Email consumer stopped due to context cancellation")
			return
		case <-ec.stopChan:
			ec.logger.Info().Msg("Email consumer stopped")
			return
		case msg, ok := <-msgs:
			if !ok {
				ec.logger.Info().Msg("Email message channel closed")
				return
			}

			ec.handleMessage(&msg)
		}
	}
}
