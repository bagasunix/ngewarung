package domains

import "time"

// TransactionItem represents items in a transaction
type TransactionItems struct {
	ID             int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	TransactionID  int64     `json:"transaction_id" gorm:"column:transaction_id"`
	ProductID      *int64    `json:"product_id" gorm:"column:product_id"`
	VariantID      *int64    `json:"variant_id" gorm:"column:variant_id"`
	Qty            int       `json:"qty" gorm:"column:qty"`
	AmountBruto    float64   `json:"amount_bruto" gorm:"column:amount_bruto"`       // price before discount
	DiscountType   *int16    `json:"discount_type" gorm:"column:discount_type"`     // 1=percent, 2=amount, 0=no discount
	DiscountValue  float64   `json:"discount_value" gorm:"column:discount_value"`   // discount value
	DiscountAmount float64   `json:"discount_amount" gorm:"column:discount_amount"` // calculated discount amount
	TaxPercent     float64   `json:"tax_percent" gorm:"column:tax_percent"`         // tax percentage
	TaxAmount      float64   `json:"tax_amount" gorm:"column:tax_amount"`           // calculated tax amount
	Subtotal       float64   `json:"subtotal" gorm:"column:subtotal"`               // final amount after discount and tax
	CreatedAt      time.Time `json:"created_at" gorm:"column:created_at"`

	// Relations
	Transaction Transactions               `json:"transaction,omitempty"`
	Product     *Products                  `json:"product,omitempty"`
	Variant     *ProductVariants           `json:"variant,omitempty"`
	Modifiers   []TransactionItemModifiers `json:"modifiers,omitempty" gorm:"foreignKey:ModifierID;references:ID"`
}

func (ti *TransactionItems) TableName() string {
	return "transaction_items"
}
