package controllers

import (
	"github.com/gofiber/fiber/v2"
	"github.com/phuslu/log"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/requests"
	"github.com/bagasunix/ngewarung/internal/delivery/dto/responses"
	"github.com/bagasunix/ngewarung/internal/repositories"
	"github.com/bagasunix/ngewarung/internal/usecases"
)

type AuthController struct {
	usecase usecases.AuthUsecase
	logger  *log.Logger
	repo    repositories.Repositories
}

func NewAuthController(logger *log.Logger, repo repositories.Repositories, usecase usecases.AuthUsecase) *AuthController {
	return &AuthController{
		usecase: usecase,
		logger:  logger,
		repo:    repo,
	}
}

func (ac *AuthController) Login(ctx *fiber.Ctx) error {
	req := new(requests.Login)
	result := new(responses.BaseResponse[*responses.ResponseLogin])

	if err := ctx.BodyParser(req); err != nil {
		result.Code = fiber.StatusBadRequest
		result.Message = "Invalid request"
		result.Errors = err
		return ctx.Status(fiber.StatusBadRequest).JSON(result)
	}

	result = ac.usecase.Login(ctx.Context(), req)
	if result.Errors != nil {
		return ctx.Status(fiber.StatusBadRequest).JSON(result)
	}

	return ctx.Status(result.Code).JSON(result)
}
