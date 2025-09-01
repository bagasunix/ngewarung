package configs

import (
	"github.com/go-redis/redis/v8"
	"github.com/gofiber/fiber/v2"
	"github.com/phuslu/log"
	"github.com/rabbitmq/amqp091-go"
	"gorm.io/gorm"

	"github.com/bagasunix/ngewarung/internal/controllers"
	"github.com/bagasunix/ngewarung/internal/delivery/http"
	"github.com/bagasunix/ngewarung/internal/repositories"
	"github.com/bagasunix/ngewarung/internal/usecases"
	"github.com/bagasunix/ngewarung/pkg/env"
)

type setupApp struct {
	DB       *gorm.DB
	App      *fiber.App
	Log      *log.Logger
	Cfg      *env.Cfg
	Redis    *redis.Client
	RabbitMQ *amqp091.Connection
}

func SetupApp(app *setupApp) *http.RouteConfig {
	app.Log.Info().Msg("Setting up application...")
	// setup repositories
	repositories := repositories.New(app.Log, app.DB)

	// setup use cases
	userUseCase := usecases.NewUserUsecase(repositories, app.Log, app.RabbitMQ)
	// setup controller
	userController := controllers.NewUserController(userUseCase, app.Log, repositories)

	return &http.RouteConfig{
		App:            app.App,
		UserController: userController,
		Cfg:            app.Cfg,
		Redis:          app.Redis,
		RabbitMQ:       app.RabbitMQ,
	}
}
