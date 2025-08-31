package domains

import "time"

// ProductVariant represents product variants (size, color, etc.)
type ProductVariants struct {
	ID        int64      `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	ProductID int64      `json:"product_id" gorm:"column:product_id"`
	Name      string     `json:"name" gorm:"column:name;size:100;not null"` // Small, Medium, Large
	SKU       *string    `json:"sku" gorm:"column:sku;size:100"`
	DeletedAt *time.Time `json:"deleted_at" gorm:"column:deleted_at"`
	CreatedAt time.Time  `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt time.Time  `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations
	Product            Products               `json:"product,omitempty"`
	Prices             []ProductVariantPrices `json:"prices,omitempty"`
	Stocks             []ProductVariantStocks `json:"stocks,omitempty"`
	PurchaseOrderItems []PurchaseOrderItems   `json:"purchase_order_items,omitempty"`
	TransactionItems   []TransactionItems     `json:"transaction_items,omitempty"`
}

func (pv *ProductVariants) TableName() string {
	return "product_variants"
}
