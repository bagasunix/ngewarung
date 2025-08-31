package middlewares

import (
	"context"
	"fmt"
	"time"

	"github.com/go-redis/redis/v8"
	"github.com/gofiber/fiber/v2"

	"github.com/bagasunix/ngewarung/pkg/env"
)

// SlidingWindowLimiter returns a Fiber middleware implementing a sliding window rate limiter using Redis.
// limit: max requests
// window: sliding window duration
// func SlidingWindowLimiter(redisClient *redis.Client, cfg *env.Cfg) fiber.Handler {
// 	return func(c *fiber.Ctx) error {
// 		ctx := context.Background()
// 		key := fmt.Sprintf("rate_limit:%s", c.IP())
// 		now := time.Now().UnixNano() / int64(time.Millisecond)
// 		duration := int64(cfg.Server.RateLimiter.Duration / time.Millisecond)
// 		min := now - duration

// 		// Remove old entries
// 		redisClient.ZRemRangeByScore(ctx, key, "-inf", fmt.Sprintf("%d", min))

// 		// Get current count
// 		count, err := redisClient.ZCard(ctx, key).Result()
// 		if err != nil {
// 			return fiber.ErrInternalServerError
// 		}

// 		if count >= int64(cfg.Server.RateLimiter.Limit) {
// 			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
// 				"error": "rate limit exceeded",
// 			})
// 		}

// 		// Add current request
// 		redisClient.ZAdd(ctx, key, &redis.Z{Score: float64(now), Member: now})
// 		redisClient.Expire(ctx, key, cfg.Server.RateLimiter.Duration*2) // ensure key expires

// 		return c.Next()
// 	}
// }

func SlidingWindowCounter(redisClient *redis.Client, cfg *env.Cfg) fiber.Handler {
	return func(c *fiber.Ctx) error {
		ctx := context.Background()
		now := time.Now().Unix()
		winSize := int64(cfg.Server.RateLimiter.Duration.Seconds())
		currWin := now / winSize
		prevWin := currWin - 1

		keyCurr := fmt.Sprintf("rate:%s:%d", c.IP(), currWin)
		keyPrev := fmt.Sprintf("rate:%s:%d", c.IP(), prevWin)

		// Tambah hitungan untuk window sekarang
		currCount, _ := redisClient.Incr(ctx, keyCurr).Result()
		// Hanya set expire kalau key baru dibuat
		// Set expire hanya kalau masih di bawah limit
		if currCount <= int64(cfg.Server.RateLimiter.Limit) {
			redisClient.Expire(ctx, keyCurr, cfg.Server.RateLimiter.Duration*2)
		}

		// Ambil hitungan window sebelumnya
		prevCount, _ := redisClient.Get(ctx, keyPrev).Int64()

		// Hitung interpolasi sliding window
		elapsed := now % winSize
		est := float64(currCount) + float64(prevCount)*(1-float64(elapsed)/float64(winSize))

		if est > float64(cfg.Server.RateLimiter.Limit) {
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
				"error": "rate limit exceeded",
			})
		}

		return c.Next()
	}
}
