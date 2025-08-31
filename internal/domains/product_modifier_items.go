package domains

// ProductModifierItem represents product-modifier relationships
type ProductModifierItems struct {
	ID         int64 `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	ProductID  int64 `json:"product_id" gorm:"column:product_id"`
	ModifierID int64 `json:"modifier_id" gorm:"column:modifier_id"`

	// Relations
	Product  Products         `json:"product,omitempty"`
	Modifier ProductModifiers `json:"modifier,omitempty"`
}

func (pmi *ProductModifierItems) TableName() string {
	return "product_modifier_items"
}
