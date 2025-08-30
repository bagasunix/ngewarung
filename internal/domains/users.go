package domains

import "time"

// User represents system users
type Users struct {
	ID         int64      `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	MerchantID *int64     `json:"merchant_id" gorm:"column:merchant_id"`
	OutletID   *int64     `json:"outlet_id" gorm:"column:outlet_id"`
	RoleID     int64      `json:"role_id" gorm:"column:role_id;not null"`
	Name       string     `json:"name" gorm:"column:name;size:150;not null"`
	Sex        int8       `json:"sex" gorm:"column:sex;not null"` // 1=male, 2=female
	Phone      string     `json:"phone" gorm:"column:phone;size:50"`
	Email      string     `json:"email" gorm:"column:email;size:150;uniqueIndex;not null"`
	Address    string     `json:"address" gorm:"column:address;type:text"`
	DOB        *string    `json:"dob" gorm:"column:dob;size:10"`
	Username   string     `json:"username" gorm:"column:username;size:50;uniqueIndex;not null"`
	Password   string     `json:"-" gorm:"column:password_hash;type:text;not null"` // hidden from JSON
	Photo      string     `json:"photo" gorm:"column:photo;type:text"`
	UserStatus int16      `json:"user_status" gorm:"column:user_status;default:1"` // 1=active, 2=inactive, 3=suspended
	IsLogin    int8       `json:"is_login" gorm:"column:is_login;default:0"`       // 0=logged out, 1=logged in
	DeletedAt  *time.Time `json:"deleted_at" gorm:"column:deleted_at"`             // soft delete
	CreatedAt  time.Time  `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt  *time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations
	Merchant *Merchants `json:"merchant,omitempty" gorm:"foreignKey:MerchantID;references:ID"`
	// Outlet       *Outlet       `json:"outlet,omitempty" gorm:"foreignKey:OutletID;references:ID"`
	Role Roles `json:"role,omitempty" gorm:"foreignKey:RoleID;references:ID"`
	// Transactions []Transaction `json:"transactions,omitempty" gorm:"foreignKey:UserID"`
}
