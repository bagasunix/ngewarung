package usecases

import (
	"context"
	"encoding/json"
	"regexp"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/phuslu/log"
	"github.com/rabbitmq/amqp091-go"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/requests"
	"github.com/bagasunix/ngewarung/internal/delivery/dto/responses"
	"github.com/bagasunix/ngewarung/internal/domains"
	"github.com/bagasunix/ngewarung/internal/repositories"
	"github.com/bagasunix/ngewarung/pkg/env"
	"github.com/bagasunix/ngewarung/pkg/errors"
	"github.com/bagasunix/ngewarung/pkg/hash"
	"github.com/bagasunix/ngewarung/pkg/helpers"
)

type userUsecase struct {
	repo   repositories.Repositories
	logger *log.Logger
	rb     *amqp091.Connection
	cfg    *env.Cfg
}

type UserUsecase interface {
	CreateUser(ctx context.Context, req *requests.UserRequest) (response *responses.BaseResponse[*responses.UserResponse])
	SendEmailRegistration(ctx context.Context, user *requests.UserRequest) error
}

func (u *userUsecase) SendEmailRegistration(ctx context.Context, user *requests.UserRequest) error {
	u.logger.Info().Msgf("Sending registration email to %s in usecase", user.Email)
	// Implement email sending logic here
	parseDatatoHtml, err := helpers.ParseTemplate("./pkg/templates/email_verification_registration.html", domains.SendEmailRegistrationCustome{
		UserName: user.Username,
		Name:     user.Name,
		Url:      "http://www.bagasunix.com",
	})
	if err != nil {
		return err
	}
	if err = helpers.SendEmail(parseDatatoHtml, user.Email, "Pendaftaran Stroberi Tagihan", u.cfg); err != nil {
		return err
	}
	return nil
}

func (u *userUsecase) CreateUser(ctx context.Context, req *requests.UserRequest) (response *responses.BaseResponse[*responses.UserResponse]) {
	res := new(responses.BaseResponse[*responses.UserResponse])
	entityBuild := new(domains.UserRegistrations)

	if err := req.Validate(); err != nil {
		res.Code = fiber.StatusBadRequest
		res.Errors = err
		res.Message = "validation error"
		return res
	}

	resultUser, err := u.repo.GetUserRegistration().FindByParams(ctx, map[string]interface{}{"email": req.Email, "phone": req.Phone})
	if err != nil {
		res.Code = fiber.StatusInternalServerError
		res.Errors = err
		res.Message = "error fetching user"
		return res
	}

	if resultUser.Error == nil && len(resultUser.Value) > 0 {
		res.Code = fiber.StatusConflict
		res.Message = "User sudah terdaftar"
		return res
	}

	// Compile regex
	phoneRegex := regexp.MustCompile(`^(?:62|08)[0-9]{8,13}$`)
	if !phoneRegex.MatchString(req.Phone) {
		res.Code = fiber.StatusBadRequest
		res.Errors = errors.CustomError(errors.ERR_INVALID_KEY + "phone number")
		res.Errors = errors.CustomError(errors.ERR_INVALID_KEY)
		return res
	} else {
		if strings.HasPrefix(req.Phone, "0") {
			entityBuild.Phone = req.Phone
		} else if strings.HasPrefix(req.Phone, "8") {
			// Menambahkan 0 di depan jika digit pertama adalah 8
			entityBuild.Phone = "0" + req.Phone
		} else if strings.HasPrefix(req.Phone, "62") {
			// Menambahkan 0 di depan jika digit pertama adalah 6 dan kedua bukan 2
			if req.Phone[2] != '8' {
				res.Code = fiber.StatusBadRequest
				res.Message = "Terjadi kesalahan, Pastikan nomor telepon Anda benar"
				res.Errors = errors.CustomError(errors.ERR_INVALID_KEY + "phone number")
				return res
			}
			entityBuild.Phone = "0" + req.Phone[2:]
		} else {
			res.Code = fiber.StatusBadRequest
			res.Message = "Terjadi kesalahan, Pastikan nomor telepon Anda benar"
			res.Errors = errors.CustomError(errors.ERR_INVALID_KEY + "phone number")
			return res
		}
	}

	entityBuild.Name = req.Name
	entityBuild.Sex = int8(req.Sex)
	entityBuild.Email = req.Email
	entityBuild.Username = req.Username
	entityBuild.Password = hash.HashAndSalt([]byte(req.Password))
	entityBuild.RoleID = 2
	entityBuild.UserStatus = 2

	// if err = u.repo.GetUserRegistration().Create(ctx, entityBuild); err != nil {
	// 	res.Code = fiber.StatusConflict
	// 	res.Message = "Gagal membuat pengguna"
	// 	res.Errors = err
	// 	return res
	// }

	bodyRb, _ := json.Marshal(entityBuild)

	// Publish to RabbitMQ
	ch, err := u.rb.Channel()
	if err != nil {
		u.logger.Error().Err(err).Msg("Failed to create RabbitMQ channel")
		return
	}
	defer ch.Close()

	err = ch.PublishWithContext(ctx, "notification", "email.registration", false, false, amqp091.Publishing{
		ContentType: "application/json",
		Body:        bodyRb,
	})
	if err != nil {
		u.logger.Error().Err(err).Msg("Failed to publish message to RabbitMQ")
		return
	}

	mBuild := new(responses.UserResponse)
	mBuild.ID = entityBuild.ID
	mBuild.Name = entityBuild.Name
	mBuild.Email = entityBuild.Email
	mBuild.RoleID = entityBuild.RoleID

	res.Code = fiber.StatusCreated
	res.Message = "User berhasil dibuat"
	res.Data = &mBuild
	return res
}

func NewUserUsecase(repo repositories.Repositories, logger *log.Logger, rb *amqp091.Connection, cfg *env.Cfg) UserUsecase {
	a := new(userUsecase)
	a.logger = logger
	a.repo = repo
	a.rb = rb
	a.cfg = cfg
	return a
}
