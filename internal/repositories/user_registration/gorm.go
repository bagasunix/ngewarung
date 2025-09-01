package user_registration

import (
	"context"

	"github.com/phuslu/log"
	"gorm.io/gorm"

	"github.com/bagasunix/ngewarung/internal/domains"
	"github.com/bagasunix/ngewarung/pkg/errors"
)

type gormRepository struct {
	db     *gorm.DB
	logger *log.Logger
}

func NewGormRepository(db *gorm.DB, logger *log.Logger) Repository {
	return &gormRepository{
		db:     db,
		logger: logger,
	}
}

func (r *gormRepository) Create(ctx context.Context, user *domains.UserRegistrations) error {
	return errors.ErrDuplicateValue(r.logger, "users", r.db.WithContext(ctx).Create(user).Error)
}

func (g *gormRepository) FindByParams(ctx context.Context, params map[string]interface{}) (m domains.SliceResult[*domains.UserRegistrations], err error) {
	m.Error = errors.ErrRecordNotFound(g.logger, "users", g.db.WithContext(ctx).Where(params).First(&m.Value).Error)
	return
}
