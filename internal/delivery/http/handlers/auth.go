package handlers

import (
	"github.com/gofiber/fiber/v2"

	"github.com/bagasunix/ngewarung/internal/controllers"
)

func MakeAuthHandler(controller *controllers.AuthController, router fiber.Router) {
	router.Post("", controller.Login)
}
