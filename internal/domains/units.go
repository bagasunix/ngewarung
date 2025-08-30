package domains

type Unit struct {
	ID           int64  `json:"id" db:"id"`
	Name         string `json:"name" db:"name"` // pcs, box, kg, liter
	Abbreviation string `json:"abbreviation" db:"abbreviation"`

	// Relations
	Products []Products `json:"products,omitempty"`
}
