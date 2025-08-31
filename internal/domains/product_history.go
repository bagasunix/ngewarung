package domains

import "time"

type ProductHistory struct {
	ID           int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	VariantID    int64     `json:"variant_id" gorm:"not null;column:variant_id"`
	OutletID     int64     `json:"outlet_id" gorm:"not null;column:outlet_id"`
	MovementType int16     `json:"movement_type" gorm:"not null;column:movement_type"`
	Quantity     int       `json:"quantity" gorm:"not null;column:quantity"`
	ReferenceID  int64     `json:"reference_id" gorm:"not null;column:reference_id"`
	Note         string    `json:"note" gorm:"column:note"`
	CreatedAt    time.Time `json:"created_at" gorm:"autoCreateTime;column:created_at"`
}

func (ph *ProductHistory) TableName() string {
	return "product_history"
}
