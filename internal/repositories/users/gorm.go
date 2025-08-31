package users

import (
	"context"

	"github.com/phuslu/log"
	"gorm.io/gorm"

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

func (g *gormProvider) FindByID(ctx context.Context, id uint) (m domains.SingleResult[*domains.Users], err error) {
	m.Error = errors.ErrRecordNotFound(g.logger, "users", g.db.WithContext(ctx).First(&m.Value, "id = ?", id).Error)
	return
}

func (g *gormProvider) FindByParams(ctx context.Context, params map[string]interface{}) (m domains.SliceResult[*domains.Users], err error) {
	m.Error = errors.ErrRecordNotFound(g.logger, "users", g.db.WithContext(ctx).Where(params).Find(&m.Value).Error)
	return
}

func NewGormProvider(logger *log.Logger, db *gorm.DB) Repository {
	g := new(gormProvider)
	g.db = db
	g.logger = logger
	return g
}
