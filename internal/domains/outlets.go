package domains

import "time"

// Outlet represents merchant branches/stores
type Outlets struct {
	ID         int64     `json:"id" gorm:"primaryKey:autoIncrement"`
	MerchantID int64     `json:"merchant_id" gorm:"column:merchant_id"`
	Name       string    `json:"name" gorm:"column:name"`
	Address    *string   `json:"address" gorm:"column:address"`
	Phone      *string   `json:"phone" gorm:"column:phone"`
	Email      string    `json:"email" gorm:"column:email;uniqueIndex"`
	CreatedAt  time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt  time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations
	Merchant             Merchants              `json:"merchant,omitempty" gorm:"foreignKey:MerchantID"`
	Users                []Users                `json:"users,omitempty" gorm:"foreignKey:OutletID"`
	ProductVariantPrices []ProductVariantPrices `json:"product_variant_prices,omitempty" gorm:"foreignKey:OutletID"`
	ProductVariantStocks []ProductVariantStocks `json:"product_variant_stocks,omitempty" gorm:"foreignKey:OutletID"`
	Transactions         []Transactions         `json:"transactions,omitempty" gorm:"foreignKey:OutletID"`
	PurchaseOrders       []PurchaseOrders       `json:"purchase_orders,omitempty" gorm:"foreignKey:OutletID"`
}
