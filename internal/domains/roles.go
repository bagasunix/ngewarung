package domains

import (
	"time"
)

// Role represents user roles (global or per merchant)
type Roles struct {
	ID         int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	MerchantID *int64    `json:"merchant_id" gorm:"column:merchant_id"`    // NULL = global role
	Name       string    `json:"name" gorm:"column:name;size:50;not null"` // superadmin, admin, cashier, manager
	CreatedAt  time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt  time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations
	Merchant *Merchants `json:"merchant,omitempty" gorm:"foreignKey:MerchantID;references:ID"`
	Users    []Users    `json:"users,omitempty" gorm:"foreignKey:RoleID;references:ID"`
}
