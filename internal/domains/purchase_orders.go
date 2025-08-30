package domains

import "time"

// PurchaseOrder represents purchase orders from suppliers
type PurchaseOrders struct {
	ID             int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	MerchantID     int64     `json:"merchant_id" gorm:"column:merchant_id"`
	SupplierID     int64     `json:"supplier_id" gorm:"column:supplier_id"`
	OutletID       *int64    `json:"outlet_id" gorm:"column:outlet_id"`
	OrderDate      time.Time `json:"order_date" gorm:"column:order_date"`
	PurchaseStatus int16     `json:"purchase_status" gorm:"column:purchase_status"` // 1=pending, 2=received, 3=cancelled

	// Relations
	Merchant Merchants            `json:"merchant,omitempty"`
	Supplier Suppliers            `json:"supplier,omitempty"`
	Outlet   *Outlets             `json:"outlet,omitempty"`
	Items    []PurchaseOrderItems `json:"items,omitempty"`
}
