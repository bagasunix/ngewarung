package db

import (
	"fmt"
	"time"
)

type DbPostgresConfig struct {
	Driver          string
	Host            string
	Port            string
	User            string
	Password        string
	DatabaseName    string
	SSLMode         string
	Timezone        string
	MaxOpenConns    int           // tambahan: max open connections
	MaxIdleConns    int           // tambahan: idle timeout
	ConnMaxLifetime time.Duration // tambahan: lifetime timeout
	ConnMaxIdleTime time.Duration // tambahan: idle timeout
}

func (d *DbPostgresConfig) GetDSN() string {
	return fmt.Sprintf("%s://%s:%s@%s:%s/%s?sslmode=%s", d.Driver, d.User, d.Password, d.Host, d.Port, d.DatabaseName, d.SSLMode)
}
