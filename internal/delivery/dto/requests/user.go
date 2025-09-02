package requests

import (
	"regexp"

	validation "github.com/go-ozzo/ozzo-validation"
)

type UserRequest struct {
	MerchantID *int64 `json:"merchant_id"`
	OutletID   *int64 `json:"outlet_id"`
	// RoleID     int64   `json:"role_id"`
	Name     string  `json:"name"`
	Sex      int     `json:"sex"`
	Phone    string  `json:"phone"`
	Email    string  `json:"email"`
	Address  string  `json:"address"`
	DOB      *string `json:"dob"`
	Username string  `json:"username"`
	Password string  `json:"password"`
	Photo    *string `json:"photo"`
}

func (r UserRequest) Validate() error {
	return validation.ValidateStruct(&r,
		// validation.Field(&r.RoleID, validation.Required),
		validation.Field(&r.Name, validation.Required, validation.Length(2, 150)),
		validation.Field(&r.Sex, validation.Required, validation.In(1, 2)),
		validation.Field(&r.Email, validation.Required, validation.Length(5, 150), validation.Match(regexp.MustCompile(`^[a-zA-Z0-9._%%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)).Error("invalid email format")),
		validation.Field(&r.Username, validation.Required, validation.Length(3, 50)),
		validation.Field(&r.Password, validation.Required, validation.Length(6, 0)),
		validation.Field(&r.Phone, validation.Length(0, 14), validation.Match(regexp.MustCompile(`^\d*$`)).Error("phone must be numeric")),
		validation.Field(&r.Address, validation.Length(0, 500)),
		validation.Field(&r.Photo, validation.Length(0, 500)),
		validation.Field(&r.MerchantID, validation.Match(regexp.MustCompile(`^\d+$`)).Error("merchant_id must be numeric")),
		validation.Field(&r.OutletID, validation.Match(regexp.MustCompile(`^\d+$`)).Error("outlet_id must be numeric")),
	)
}
