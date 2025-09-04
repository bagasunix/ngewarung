package usecases

import (
	"context"
	errs "errors"
	"strconv"
	"time"

	"github.com/go-redis/redis/v8"
	"github.com/gofiber/fiber/v2"
	"github.com/phuslu/log"
	"gorm.io/gorm"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/requests"
	"github.com/bagasunix/ngewarung/internal/delivery/dto/responses"
	"github.com/bagasunix/ngewarung/internal/repositories"
	"github.com/bagasunix/ngewarung/pkg/env"
	"github.com/bagasunix/ngewarung/pkg/errors"
	"github.com/bagasunix/ngewarung/pkg/hash"
	"github.com/bagasunix/ngewarung/pkg/jwt"
)

type authUsecase struct {
	db     *gorm.DB
	redis  *redis.Client
	cfg    *env.Cfg
	repo   repositories.Repositories
	logger *log.Logger
}

type AuthUsecase interface {
	Login(ctx context.Context, req *requests.Login) (resonses *responses.BaseResponse[*responses.ResponseLogin])
}

func NewAuthUsecase(logger *log.Logger, db *gorm.DB, cfg *env.Cfg, repo repositories.Repositories, redis *redis.Client) AuthUsecase {
	n := new(authUsecase)
	n.cfg = cfg
	n.db = db
	n.logger = logger
	n.redis = redis
	n.repo = repo
	return n
}

func (au *authUsecase) Login(ctx context.Context, req *requests.Login) (resonses *responses.BaseResponse[*responses.ResponseLogin]) {
	responseBuild := new(responses.BaseResponse[*responses.ResponseLogin])
	if req.Validate() != nil {
		responseBuild.Code = fiber.StatusBadRequest
		responseBuild.Message = "Validasi error"
		responseBuild.Errors = req.Validate()
		return responseBuild
	}

	checkUser, err := au.repo.GetUser().FindByParams(ctx, map[string]interface{}{"username": req.Username})
	if len(checkUser.Value.Email) == 0 || errs.Is(err, gorm.ErrRecordNotFound) {
		responseBuild.Code = fiber.StatusNotFound
		responseBuild.Message = "Email tidak ditemukan"
		responseBuild.Errors = errors.CustomError("email " + errors.ERR_NOT_FOUND)
		return responseBuild
	}

	if err != nil && !errs.Is(err, gorm.ErrRecordNotFound) {
		responseBuild.Code = fiber.StatusNotFound
		responseBuild.Message = err.Error()
		responseBuild.Errors = err
		return responseBuild
	}

	if !hash.ComparePasswords(checkUser.Value.Password, []byte(req.Password)) {
		responseBuild.Code = fiber.StatusNotFound
		responseBuild.Message = "username and password salah"
		responseBuild.Errors = errors.ErrInvalidAttributes("username and password")
		return responseBuild
	}

	userBuild := responses.UserResponse{}
	userBuild.ID = checkUser.Value.ID
	userBuild.Name = checkUser.Value.Name
	userBuild.Sex = checkUser.Value.Sex
	userBuild.Phone = checkUser.Value.Phone
	userBuild.Email = checkUser.Value.Email
	userBuild.Address = checkUser.Value.Address
	userBuild.DOB = checkUser.Value.DOB
	userBuild.Photo = checkUser.Value.Photo
	userBuild.Username = checkUser.Value.Username
	userBuild.RoleID = checkUser.Value.RoleID
	userBuild.UserStatus = int16(checkUser.Value.UserStatus)

	clm := new(jwt.Claims)
	clm.User = &userBuild
	clm.ExpiresAt = time.Now().Add(1 * time.Hour).Unix()

	token, err := jwt.GenerateToken(au.cfg.Server.Token.JWTKey, *clm)
	if err != nil {
		responseBuild.Code = fiber.StatusConflict
		responseBuild.Message = "Gagal membuat token"
		responseBuild.Errors = err
		return responseBuild
	}

	redisKey := "auth:token:" + strconv.Itoa(int(userBuild.ID))
	err = au.redis.Set(ctx, redisKey, token, time.Hour).Err()
	if err != nil {
		responseBuild.Code = fiber.StatusConflict
		responseBuild.Message = "Gagal menyimpan token di Redis"
		responseBuild.Errors = err
		return responseBuild
	}

	resBuild := new(responses.ResponseLogin)
	resBuild.ID = strconv.Itoa(int(userBuild.ID))
	resBuild.Token = token

	responseBuild.Data = &resBuild
	responseBuild.Code = 200
	responseBuild.Message = "Pengguna berhasil masuk"
	return responseBuild
}
