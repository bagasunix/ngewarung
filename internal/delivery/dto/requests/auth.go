package requests

import (
	validation "github.com/go-ozzo/ozzo-validation"
)

type Login struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func (l Login) Validate() error {
	return validation.ValidateStruct(&l,
		// validation.Field(&r.RoleID, validation.Required),
		validation.Field(&l.Username, validation.Required, validation.Length(3, 50)),
		validation.Field(&l.Password, validation.Required, validation.Length(6, 0)),
	)
}
