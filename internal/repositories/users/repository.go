package users

import (
	"context"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/responses"
	"github.com/bagasunix/ngewarung/internal/domains"
)

type Repository interface {
	Create(ctx context.Context, user *domains.Users) error
	FindByID(ctx context.Context, id uint) (m responses.BaseResponse[*domains.Users], err error)
}
