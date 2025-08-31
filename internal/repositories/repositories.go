package repositories

import (
	"github.com/phuslu/log"
	"gorm.io/gorm"

	"github.com/bagasunix/ngewarung/internal/repositories/users"
)

type Repositories interface {
	GetUser() users.Repository
}

type repo struct {
	user users.Repository
}

func (r *repo) GetUser() users.Repository {
	return r.user
}

func New(logger *log.Logger, db *gorm.DB) Repositories {
	rs := new(repo)
	rs.user = users.NewGormProvider(logger, db)
	return rs
}
