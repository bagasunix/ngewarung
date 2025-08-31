package domains

// PurchaseOrderItem represents items in purchase orders
type PurchaseOrderItems struct {
	ID              int64   `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	PurchaseOrderID int64   `json:"purchase_order_id" gorm:"column:purchase_order_id"`
	VariantID       int64   `json:"variant_id" gorm:"column:variant_id"`
	Quantity        int     `json:"quantity" gorm:"column:quantity"`
	Price           float64 `json:"price" gorm:"column:price"`

	// Relations
	PurchaseOrder PurchaseOrders  `json:"purchase_order,omitempty"`
	Variant       ProductVariants `json:"variant,omitempty"`
}

func (poi *PurchaseOrderItems) TableName() string {
	return "purchase_order_items"
}
