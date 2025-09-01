package handlers

import (
	"github.com/gofiber/fiber/v2"

	"github.com/bagasunix/ngewarung/internal/controllers"
)

func MakeUserHandler(controller *controllers.UserController, router fiber.Router) {
	router.Post("", controller.CreateUser)
}
