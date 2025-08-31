package domains

import "time"

// ProductVariantPrice represents variant prices per outlet
type ProductVariantPrices struct {
	ID        int64      `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	VariantID int64      `json:"variant_id" gorm:"column:variant_id"`
	OutletID  int64      `json:"outlet_id" gorm:"column:outlet_id"`
	Price     float64    `json:"price" gorm:"column:price"`
	CreatedAt time.Time  `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt time.Time  `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`
	DeletedAt *time.Time `json:"deleted_at" gorm:"column:deleted_at"`

	// Relations
	Variant ProductVariants `json:"variant,omitempty"`
	Outlet  Outlets         `json:"outlet,omitempty"`
}

func (pvp *ProductVariantPrices) TableName() string {
	return "product_variant_prices"
}
