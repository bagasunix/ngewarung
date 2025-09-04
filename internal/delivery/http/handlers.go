package http

import (
	"log"

	"github.com/go-redis/redis/v8"
	"github.com/gofiber/fiber/v2"
	"github.com/rabbitmq/amqp091-go"

	"github.com/bagasunix/ngewarung/internal/controllers"
	"github.com/bagasunix/ngewarung/internal/delivery/http/handlers"
	"github.com/bagasunix/ngewarung/pkg/env"
)

type RouteConfig struct {
	App            *fiber.App
	UserController *controllers.UserController
	AuthController *controllers.AuthController
	Cfg            *env.Cfg
	Rc             *redis.Client
	Logger         *log.Logger
	Amqp           *amqp091.Connection
}

func InitHttpHandler(f *RouteConfig) *fiber.App {
	return NewHttpHandler(*f)
}

func NewHttpHandler(r RouteConfig) *fiber.App {
	// Initialize middleware
	// Handlers
	handlers.MakeUserHandler(r.UserController, r.App.Group(r.Cfg.Server.Version+"/users").(*fiber.Group))
	handlers.MakeAuthHandler(r.AuthController, r.App.Group(r.Cfg.Server.Version+"/auth").(*fiber.Group))
	return r.App
}
