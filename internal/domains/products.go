package domains

import "time"

// Product represents main product entity
type Products struct {
	ID          int64      `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	MerchantID  int64      `json:"merchant_id" gorm:"column:merchant_id"`
	CategoryID  *int64     `json:"category_id" gorm:"column:category_id"`
	UnitID      *int64     `json:"unit_id" gorm:"column:unit_id"`
	Name        string     `json:"name" gorm:"column:name;not null"`
	SKU         *string    `json:"sku" gorm:"column:sku;size:100"`
	Barcode     *string    `json:"barcode" gorm:"column:barcode"`
	Description *string    `json:"description" gorm:"column:description"`
	IsActive    bool       `json:"is_active" gorm:"column:is_active"`
	DeletedAt   *time.Time `json:"deleted_at" gorm:"column:deleted_at"`
	CreatedAt   time.Time  `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt   time.Time  `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations
	Merchant         Merchants              `json:"merchant,omitempty"`
	Category         *ProductCategory       `json:"category,omitempty"`
	Unit             *Unit                  `json:"unit,omitempty"`
	Variants         []ProductVariants      `json:"variants,omitempty"`
	ModifierItems    []ProductModifierItems `json:"modifier_items,omitempty"`
	TransactionItems []TransactionItems     `json:"transaction_items,omitempty"`
}

func (p *Products) TableName() string {
	return "products"
}
