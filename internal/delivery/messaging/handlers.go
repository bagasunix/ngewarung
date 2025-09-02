package messaging

import (
	"context"

	"github.com/phuslu/log"
	"github.com/rabbitmq/amqp091-go"

	"github.com/bagasunix/ngewarung/internal/delivery/messaging/handlers"
	"github.com/bagasunix/ngewarung/internal/repositories"
	"github.com/bagasunix/ngewarung/internal/usecases"
	"github.com/bagasunix/ngewarung/pkg/env"
)

type RouteConfig struct {
	Ctx     context.Context
	Cfg     *env.Cfg
	Log     *log.Logger
	Amqp    *amqp091.Connection
	Repo    repositories.Repositories
	Usecase usecases.UserUsecase
}

func InitRabbitMQHandler(ctx context.Context, cfg *env.Cfg, log *log.Logger, amqp *amqp091.Connection, repo repositories.Repositories, usecase usecases.UserUsecase) *amqp091.Connection {
	ch, err := amqp.Channel()
	if err != nil {
		log.Error().Err(err).Msg("Failed to create RabbitMQ channel")
	}
	go handlers.RunEmailConsumer(ctx, log, cfg, ch, usecase)
	return amqp
}
