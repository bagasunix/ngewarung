package domains

// TransactionItemModifier represents modifiers applied to transaction items
type TransactionItemModifiers struct {
	ID                int64   `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	TransactionItemID int64   `json:"transaction_item_id" gorm:"column:transaction_item_id"`
	ModifierID        *int64  `json:"modifier_id" gorm:"column:modifier_id"`
	Price             float64 `json:"price" gorm:"column:price"`

	// Relations
	TransactionItem TransactionItems  `json:"transaction_item,omitempty"`
	Modifier        *ProductModifiers `json:"modifier,omitempty"`
}
