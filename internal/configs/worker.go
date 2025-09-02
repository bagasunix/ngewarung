package configs

import (
	"context"
	"os"
	"os/signal"
	"syscall"

	"github.com/bagasunix/ngewarung/internal/delivery/messaging"
	"github.com/bagasunix/ngewarung/internal/repositories"
	"github.com/bagasunix/ngewarung/internal/usecases"
	"github.com/bagasunix/ngewarung/pkg/env"
)

func RunWorker() {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	logger := InitLogger()
	logger.Info().Msg("Starting worker...")
	cfg := env.InitConfig(ctx, logger)
	db := InitDB(ctx, cfg, logger)
	rabbitConn := InitRabbitMQ(ctx, cfg, logger)

	repo := repositories.New(logger, db)
	userUsecase := usecases.NewUserUsecase(repo, logger, rabbitConn)

	// Inisialisasi dan jalankan semua consumers
	consumerManager := messaging.NewConsumerManager(ctx, cfg, logger, rabbitConn, repo, userUsecase)
	consumerManager.StartAllConsumers()

	// Tunggu sinyal shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	// Tunggu sinyal
	sig := <-sigChan
	logger.Info().Msgf("Received signal: %s, shutting down...", sig)

	// Langsung tutup koneksi RabbitMQ (akan memaksa semua consumer berhenti)
	if rabbitConn != nil {
		logger.Info().Msg("Force closing RabbitMQ connection...")
		if err := rabbitConn.Close(); err != nil {
			logger.Error().Err(err).Msg("Failed to close RabbitMQ connection")
		} else {
			logger.Info().Msg("RabbitMQ connection closed successfully")
		}
	}

	logger.Info().Msg("Worker shutdown completed")
}

// func initCancelWorker(errs chan<- error, cancel context.CancelFunc) {
// 	c := make(chan os.Signal, 1)
// 	signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
// 	sig := <-c
// 	cancel()
// 	errs <- fmt.Errorf("%s", sig)
// }
