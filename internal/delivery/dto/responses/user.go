package responses

import "time"

type UserResponse struct {
	ID         int64      `json:"id"`
	MerchantID *int64     `json:"merchant_id,omitempty"`
	OutletID   *int64     `json:"outlet_id,omitempty"`
	RoleID     int64      `json:"role_id"`
	Name       string     `json:"name"`
	Sex        int8       `json:"sex"`
	Phone      string     `json:"phone"`
	Email      string     `json:"email"`
	Address    string     `json:"address"`
	DOB        *string    `json:"dob,omitempty"`
	Username   string     `json:"username"`
	Photo      string     `json:"photo"`
	UserStatus int16      `json:"user_status"`
	IsLogin    int8       `json:"is_login"`
	DeletedAt  *time.Time `json:"deleted_at,omitempty"`
	CreatedAt  time.Time  `json:"created_at"`
	UpdatedAt  *time.Time `json:"updated_at,omitempty"`
}
