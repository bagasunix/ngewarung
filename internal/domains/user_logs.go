package domains

import "time"

type UserLogs struct {
	ID         int64     `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	UserID     int64     `json:"user_id" gorm:"column:user_id;not null"`
	Action     int8      `json:"action" gorm:"column:action;not null"` // 1=login, 2=logout, 3=failed_login, 4=change_password
	IPAddress  string    `json:"ip_address" gorm:"column:ip_address;size:50"`
	UserAgent  string    `json:"user_agent" gorm:"column:user_agent;type:text"`
	DeviceInfo string    `json:"device_info" gorm:"column:device_info;type:text"`
	CreatedAt  time.Time `json:"created_at" gorm:"column:created_at;autoCreateTime"`
}

func (ul *UserLogs) TableName() string {
	return "user_logs"
}
