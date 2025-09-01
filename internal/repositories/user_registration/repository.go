package user_registration

import (
	"context"

	"github.com/bagasunix/ngewarung/internal/domains"
)

type Repository interface {
	Create(ctx context.Context, user *domains.UserRegistrations) error
	FindByParams(ctx context.Context, params map[string]interface{}) (m domains.SliceResult[*domains.UserRegistrations], err error)
}
