package domains

import "time"

// Merchants represents the tenant in multi-tenant architecture
type Merchants struct {
	ID             int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	Name           string    `json:"name" gorm:"column:name;size:200;not null"`
	Email          string    `json:"email" gorm:"column:email;size:150;uniqueIndex;not null"`
	Phone          *string   `json:"phone" gorm:"column:phone;size:50"`
	Address        *string   `json:"address" gorm:"column:address;type:text"`
	MerchantStatus int16     `json:"merchant_status" gorm:"column:merchant_status;default:1"` // 1=active, 2=suspended
	CreatedAt      time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt      time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations - GORM akan otomatis mendeteksi berdasarkan foreign key
	Outlets   []Outlets   `json:"outlets,omitempty" gorm:"foreignKey:MerchantID"`
	Users     []Users     `json:"users,omitempty" gorm:"foreignKey:MerchantID;references:ID"`
	Products  []Products  `json:"products,omitempty" gorm:"foreignKey:MerchantID"`
	Suppliers []Suppliers `json:"suppliers,omitempty" gorm:"foreignKey:MerchantID"`
	Roles     []Roles     `json:"roles,omitempty" gorm:"foreignKey:MerchantID;references:ID"`
}

func (m *Merchants) TableName() string {
	return "merchants"
}
