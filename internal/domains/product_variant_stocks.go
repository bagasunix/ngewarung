package domains

import "time"

// ProductVariantStock represents variant stock per outlet
type ProductVariantStocks struct {
	ID        int64      `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	VariantID int64      `json:"variant_id" gorm:"column:variant_id"`
	OutletID  int64      `json:"outlet_id" gorm:"column:outlet_id"`
	Quantity  int        `json:"quantity" gorm:"column:quantity"`
	UpdatedAt time.Time  `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`
	DeletedAt *time.Time `json:"deleted_at" gorm:"column:deleted_at"`

	// Relations
	Variant ProductVariants `json:"variant,omitempty"`
	Outlet  Outlets         `json:"outlet,omitempty"`
}

func (pvs *ProductVariantStocks) TableName() string {
	return "product_variant_stocks"
}
