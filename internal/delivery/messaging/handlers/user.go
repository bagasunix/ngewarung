package handlers

import (
	"context"
	"encoding/json"

	"github.com/phuslu/log"
	"github.com/rabbitmq/amqp091-go"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/requests"
	"github.com/bagasunix/ngewarung/internal/usecases"
	"github.com/bagasunix/ngewarung/pkg/env"
)

func RunEmailConsumer(ctx context.Context, logger *log.Logger, cfg *env.Cfg, ch *amqp091.Channel, userUsecase usecases.UserUsecase) {
	logger.Info().Msg("Setup user consumer...")

	emailConsumer, err := ch.ConsumeWithContext(ctx, "email", "consumer-user", true, false, false, false, nil)
	if err != nil {
		logger.Error().Err(err).Msg("Failed to register email consumer")
		return
	}

	for {
		select {
		case msg, ok := <-emailConsumer:
			if !ok {
				logger.Info().Msg("Email consumer channel closed")
				return
			}
			switch msg.RoutingKey {
			case "email.registration":
				logger.Info().Msgf("Received email message: %s", msg.RoutingKey)

				user := new(requests.UserRequest)
				if err := json.Unmarshal(msg.Body, &user); err != nil {
					logger.Error().Err(err).Msg("Failed to unmarshal user registration message")
					continue
				}

				if err := userUsecase.SendEmailRegistration(ctx, user); err != nil {
					logger.Error().Err(err).Msg("Failed to send registration email")
				} else {
					logger.Info().Msgf("Registration email sent to %s", user.Email)
				}
			}
		case <-ctx.Done():
			logger.Info().Msg("Stopping email consumer due to context cancellation")
			ch.Close() // Tutup channel saat context dibatalkan
			return
		}
	}
}
