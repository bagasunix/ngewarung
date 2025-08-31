package users

import (
	"context"

	"github.com/phuslu/log"
	"gorm.io/gorm"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/responses"
	"github.com/bagasunix/ngewarung/internal/domains"
	"github.com/bagasunix/ngewarung/pkg/errors"
)

type gormProvider struct {
	db     *gorm.DB
	logger *log.Logger
}

func (g *gormProvider) Create(ctx context.Context, m *domains.Users) error {
	return errors.ErrDuplicateValue(g.logger, "users", g.db.WithContext(ctx).Create(m).Error)
}

func (g *gormProvider) FindByID(ctx context.Context, id uint) (m responses.BaseResponse[*domains.Users], err error) {
	m.Errors = errors.ErrRecordNotFound(g.logger, "users", g.db.WithContext(ctx).First(&m.Data, "id = ?", id).Error)
	return
}

func NewGormProvider(logger *log.Logger, db *gorm.DB) Repository {
	g := new(gormProvider)
	g.db = db
	g.logger = logger
	return g
}
