package users

import (
	"context"

	"github.com/bagasunix/ngewarung/internal/domains"
)

type Repository interface {
	Create(ctx context.Context, user *domains.Users) error

	FindByID(ctx context.Context, id uint) (m domains.SingleResult[*domains.Users], err error)
	FindByParams(ctx context.Context, params map[string]interface{}) (m domains.SingleResult[*domains.Users], err error)
}
