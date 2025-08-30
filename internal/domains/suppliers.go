package domains

import "time"

// Supplier represents product suppliers
type Suppliers struct {
	ID            int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	MerchantID    int64     `json:"merchant_id" gorm:"column:merchant_id"`
	Name          string    `json:"name" gorm:"column:name;size:100;not null"`
	ContactPerson *string   `json:"contact_person" gorm:"column:contact_person;size:100"`
	Phone         *string   `json:"phone" gorm:"column:phone;size:50"`
	Address       *string   `json:"address" gorm:"column:address;type:text"`
	CreatedAt     time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt     time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations
	Merchant       Merchants        `json:"merchant,omitempty"`
	PurchaseOrders []PurchaseOrders `json:"purchase_orders,omitempty"`
}
