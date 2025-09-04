package jwt

import (
	"time"

	"github.com/dgrijalva/jwt-go"

	"github.com/bagasunix/ngewarung/internal/delivery/dto/responses"
)

type Claims struct {
	User *responses.UserResponse `json:"user,omitempty"`
	jwt.StandardClaims
}

// Fungsi untuk membuat Claims langsung
func NewClaims(user *responses.UserResponse, expiresAt time.Time) *Claims {
	return &Claims{
		User: user,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expiresAt.Unix(),
		},
	}
}
