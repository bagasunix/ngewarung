package controllers

import (
	"github.com/gofiber/fiber/v2"
	"github.com/phuslu/log"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/requests"
	"github.com/bagasunix/ngewarung/internal/delivery/dto/responses"
	"github.com/bagasunix/ngewarung/internal/repositories"
	"github.com/bagasunix/ngewarung/internal/usecases"
)

type UserController struct {
	usecase usecases.UserUsecase
	logger  *log.Logger
	repo    repositories.Repositories
}

func NewUserController(usecase usecases.UserUsecase, logger *log.Logger, repo repositories.Repositories) *UserController {
	return &UserController{
		usecase: usecase,
		logger:  logger,
		repo:    repo,
	}
}

func (uc *UserController) CreateUser(ctx *fiber.Ctx) error {
	req := new(requests.UserRequest)
	res := new(responses.BaseResponse[responses.UserResponse])
	if err := ctx.BodyParser(req); err != nil {
		res.Code = fiber.StatusBadRequest
		res.Message = "Invalid request"
		res.Errors = err
		return ctx.Status(fiber.StatusBadRequest).JSON(res)
	}

	us := uc.usecase.CreateUser(ctx.Context(), req)
	if us.Errors != nil {
		return ctx.Status(us.Code).JSON(us)
	}

	return ctx.Status(us.Code).JSON(us)
}
