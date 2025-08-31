package domains

import "time"

// Transaction represents sales transactions
type Transactions struct {
	ID                int64      `json:"id" db:"id"`
	MerchantID        int64      `json:"merchant_id" db:"merchant_id"`
	OutletID          int64      `json:"outlet_id" db:"outlet_id"`
	UserID            int64      `json:"user_id" db:"user_id"`
	Total             float64    `json:"total" db:"total"`
	PaymentMethod     int16      `json:"payment_method" db:"payment_method"`         // 1=cash, 2=card, 3=e-wallet
	TransactionStatus int16      `json:"transaction_status" db:"transaction_status"` // 1=pending, 2=paid, 3=cancelled
	DeletedAt         *time.Time `json:"deleted_at" db:"deleted_at"`
	CreatedAt         time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt         time.Time  `json:"updated_at" db:"updated_at"`

	// Relations
	Merchant Merchants          `json:"merchant,omitempty"`
	Outlet   Outlets            `json:"outlet,omitempty"`
	User     Users              `json:"user,omitempty"`
	Items    []TransactionItems `json:"items,omitempty"`
}

func (t *Transactions) TableName() string {
	return "transactions"
}
