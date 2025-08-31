package domains

import "time"

// ProductCategory represents product categories per merchant
type ProductCategory struct {
	ID         int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	MerchantID int64     `json:"merchant_id" gorm:"column:merchant_id"`
	Name       string    `json:"name" gorm:"column:name;size:100;not null"`
	CreatedAt  time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt  time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations
	Merchant Merchants  `json:"merchant,omitempty"`
	Products []Products `json:"products,omitempty"`
}

func (pc *ProductCategory) TableName() string {
	return "product_categories"
}
