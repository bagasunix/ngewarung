package domains

import "time"

type UserRegistrations struct {
	ID         int64      `json:"id" gorm:"primaryKey;autoIncrement;column:id"`
	Name       string     `json:"name" gorm:"column:name;size:150;not null"`
	Sex        int8       `json:"sex" gorm:"column:sex;not null"` // 1=male, 2=female
	Phone      string     `json:"phone" gorm:"column:phone;size:50"`
	Email      string     `json:"email" gorm:"column:email;size:150;uniqueIndex;not null"`
	Username   string     `json:"username" gorm:"column:username;size:50;uniqueIndex;not null"`
	Password   string     `json:"-" gorm:"column:password_hash;type:text;not null"` // hidden from JSON
	UserStatus int16      `json:"user_status" gorm:"column:user_status;default:1"`  // 1=active, 2=pending, 3=suspended
	RoleID     int64      `json:"role_id" gorm:"column:role_id;not null"`
	DeletedAt  *time.Time `json:"deleted_at" gorm:"column:deleted_at"` // soft delete
	CreatedAt  time.Time  `json:"created_at" gorm:"column:created_at;autoCreateTime"`
	UpdatedAt  *time.Time `json:"updated_at" gorm:"column:updated_at;autoUpdateTime"`
}

func (u *UserRegistrations) TableName() string {
	return "user_registrations"
}
