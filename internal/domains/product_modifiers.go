package domains

import "time"

// ProductModifier represents modifiers (toppings, extras, etc.)
type ProductModifiers struct {
	ID         int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	MerchantID int64     `json:"merchant_id" gorm:"column:merchant_id"`
	Name       string    `json:"name" gorm:"column:name"`
	Price      float64   `json:"price" gorm:"column:price"`
	CreatedAt  time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt  time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`

	// Relations
	Merchant                 Merchants                  `json:"merchant,omitempty"`
	ProductModifierItems     []ProductModifierItems     `json:"product_modifier_items,omitempty" gorm:"foreignKey:ModifierID;references:ID"`
	TransactionItemModifiers []TransactionItemModifiers `json:"transaction_item_modifiers,omitempty" gorm:"foreignKey:ModifierID;references:ID"`
}

func (pm *ProductModifiers) TableName() string {
	return "product_modifiers"
}
