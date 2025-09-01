package repositories

import (
	"github.com/phuslu/log"
	"gorm.io/gorm"

	"github.com/bagasunix/ngewarung/internal/repositories/user_registration"
	"github.com/bagasunix/ngewarung/internal/repositories/users"
)

type Repositories interface {
	GetUser() users.Repository
	GetUserRegistration() user_registration.Repository
}

type repo struct {
	user              users.Repository
	user_registration user_registration.Repository
}

func (r *repo) GetUser() users.Repository {
	return r.user
}

func (r *repo) GetUserRegistration() user_registration.Repository {
	return r.user_registration
}

func New(logger *log.Logger, db *gorm.DB) Repositories {
	rs := new(repo)
	rs.user = users.NewGormProvider(logger, db)
	rs.user_registration = user_registration.NewGormRepository(db, logger)
	return rs
}
