package messaging

import (
	"context"
	"sync"
	"time"

	"github.com/phuslu/log"
	"github.com/rabbitmq/amqp091-go"

	"github.com/bagasunix/ngewarung/internal/repositories"
	"github.com/bagasunix/ngewarung/internal/usecases"
	"github.com/bagasunix/ngewarung/pkg/env"
)

// ConsumerManager mengelola semua consumers
type ConsumerManager struct {
	ctx       context.Context
	cancel    context.CancelFunc
	cfg       *env.Cfg
	logger    *log.Logger
	amqpConn  *amqp091.Connection
	repo      repositories.Repositories
	usecase   usecases.UserUsecase
	consumers []Consumer
	wg        sync.WaitGroup
	mu        sync.Mutex
}

// Consumer interface untuk semua types of consumers
type Consumer interface {
	Start() error
	Stop() error
	Name() string
}

// NewConsumerManager membuat instance baru ConsumerManager
func NewConsumerManager(ctx context.Context, cfg *env.Cfg, logger *log.Logger,
	amqpConn *amqp091.Connection, repo repositories.Repositories,
	usecase usecases.UserUsecase) *ConsumerManager {

	childCtx, cancel := context.WithCancel(ctx)
	return &ConsumerManager{
		ctx:       childCtx,
		cancel:    cancel,
		cfg:       cfg,
		logger:    logger,
		amqpConn:  amqpConn,
		repo:      repo,
		usecase:   usecase,
		consumers: []Consumer{},
	}
}

// StartAllConsumers memulai semua registered consumers
func (cm *ConsumerManager) StartAllConsumers() {
	// Daftarkan semua consumers di sini
	cm.RegisterConsumer(NewEmailConsumer(cm.ctx, cm.cfg, cm.logger, cm.amqpConn, cm.usecase))
	cm.RegisterConsumer(NewSMSConsumer(cm.ctx, cm.cfg, cm.logger, cm.amqpConn, cm.usecase))
	// Tambahkan consumers lain di sini

	for _, consumer := range cm.consumers {
		cm.wg.Add(1)
		go func(c Consumer) {
			defer cm.wg.Done()
			cm.runConsumer(c)
		}(consumer)
	}
}

// runConsumer menjalankan consumer tanpa mekanisme restart otomatis
// (restart dapat ditangani oleh supervisor eksternal seperti systemd/docker)
func (cm *ConsumerManager) runConsumer(consumer Consumer) {
	cm.logger.Info().Msgf("Starting %s", consumer.Name())

	if err := consumer.Start(); err != nil {
		cm.logger.Error().Err(err).Msgf("%s failed to start", consumer.Name())
	}

	// Tunggu hingga context dibatalkan
	<-cm.ctx.Done()

	// Hentikan consumer
	if err := consumer.Stop(); err != nil {
		cm.logger.Error().Err(err).Msgf("Failed to stop consumer: %s", consumer.Name())
	}

	cm.logger.Info().Msgf("%s stopped", consumer.Name())
}

// StopAllConsumers menghentikan semua consumers dengan cepat
func (cm *ConsumerManager) StopAllConsumers() {
	cm.logger.Info().Msg("Stopping all consumers...")

	// Batalkan context untuk memberi sinyal stop ke semua consumers
	cm.cancel()

	// Beri waktu sangat singkat untuk graceful shutdown
	timeout := time.After(3 * time.Second) // Dikurangi dari 30 detik menjadi 3 detik
	done := make(chan struct{})

	go func() {
		cm.wg.Wait()
		close(done)
	}()

	select {
	case <-done:
		cm.logger.Info().Msg("All consumers stopped gracefully")
	case <-timeout:
		cm.logger.Warn().Msg("Timeout waiting for consumers to stop, forcing shutdown")
		// Tidak perlu menunggu lebih lama, biarkan proses berakhir
	}
}

// RegisterConsumer menambahkan consumer ke manager
func (cm *ConsumerManager) RegisterConsumer(consumer Consumer) {
	cm.mu.Lock()
	defer cm.mu.Unlock()
	cm.consumers = append(cm.consumers, consumer)
}
