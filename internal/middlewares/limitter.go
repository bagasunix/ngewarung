package middlewares

import (
	"context"
	"fmt"
	"math"
	"strconv"
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

func TokenBucketLimiter(redisClient *redis.Client, capacity, refillRate int, refillInterval time.Duration) fiber.Handler {
	return func(c *fiber.Ctx) error {
		ctx := context.Background()
		ip := c.IP()
		keyTokens := fmt.Sprintf("bucket:%s:tokens", ip)
		keyTimestamp := fmt.Sprintf("bucket:%s:ts", ip)

		now := time.Now().Unix()

		// Ambil data dari Redis
		tokens, _ := redisClient.Get(ctx, keyTokens).Int()
		lastRefill, _ := redisClient.Get(ctx, keyTimestamp).Int64()

		if lastRefill == 0 {
			lastRefill = now
			tokens = capacity // inisialisasi penuh
		}

		// Hitung berapa token yang harus direfill
		elapsed := now - lastRefill
		refill := int(elapsed) * refillRate
		if refill > 0 {
			tokens = func(a, b int) int {
				if a < b {
					return a
				}
				return b
			}(capacity, tokens+refill)
			lastRefill = now
		}

		// Cek apakah masih ada token
		if tokens <= 0 {
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
				"error":   "Too many requests",
				"message": "Rate limit exceeded",
				"code":    429,
			})
		}

		// Ambil 1 token
		tokens--

		// Simpan lagi ke Redis dengan TTL biar nggak "panjang umur"
		pipe := redisClient.TxPipeline()
		pipe.Set(ctx, keyTokens, tokens, refillInterval*2)
		pipe.Set(ctx, keyTimestamp, lastRefill, refillInterval*2)
		_, _ = pipe.Exec(ctx)

		return c.Next()
	}
}

func HybridRateLimiter(redisClient *redis.Client, cfg *env.Cfg) fiber.Handler {
	return func(c *fiber.Ctx) error {
		ctx := context.Background()
		ip := c.IP()
		now := time.Now().Unix()

		// ----- TOKEN BUCKET -----
		bucketKey := fmt.Sprintf("bucket:%s", ip)
		// isi ulang token (refill_rate token per detik)
		refillRate := float64(cfg.Server.RateLimiter.Limit) / cfg.Server.RateLimiter.Duration.Seconds()
		capacity := cfg.Server.RateLimiter.Limit

		pipe := redisClient.TxPipeline()
		// Ambil token dan timestamp terakhir
		vals, _ := redisClient.HMGet(ctx, bucketKey, "tokens", "ts").Result()
		tokens, _ := strconv.ParseFloat(fmt.Sprint(vals[0]), 64)
		lastTs, _ := strconv.ParseInt(fmt.Sprint(vals[1]), 10, 64)

		if lastTs == 0 { // belum ada data, inisialisasi
			tokens = float64(capacity)
			lastTs = now
		}

		// Hitung refill
		elapsed := now - lastTs
		tokens = math.Min(float64(capacity), tokens+float64(elapsed)*refillRate)
		lastTs = now

		// Ambil 1 token
		if tokens < 1 {
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{"error": "token bucket empty"})
		}
		tokens--

		// Simpan kembali
		pipe.HSet(ctx, bucketKey, "tokens", tokens, "ts", lastTs)
		pipe.Expire(ctx, bucketKey, cfg.Server.RateLimiter.Duration*2)
		_, _ = pipe.Exec(ctx)

		// ----- SLIDING WINDOW -----
		winSize := int64(cfg.Server.RateLimiter.Duration.Seconds())
		currWin := now / winSize
		prevWin := currWin - 1
		keyCurr := fmt.Sprintf("sw:%s:%d", ip, currWin)
		keyPrev := fmt.Sprintf("sw:%s:%d", ip, prevWin)

		currCount, _ := redisClient.Incr(ctx, keyCurr).Result()
		if currCount == 1 {
			redisClient.Expire(ctx, keyCurr, cfg.Server.RateLimiter.Duration*2)
		}
		prevCount, _ := redisClient.Get(ctx, keyPrev).Int64()

		elapsedWin := now % winSize
		est := float64(currCount) + float64(prevCount)*(1-float64(elapsedWin)/float64(winSize))

		if est > float64(cfg.Server.RateLimiter.Limit) {
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{"error": "sliding window exceeded"})
		}

		// ----- ADAPTIVE (contoh sederhana) -----
		// kalau request > 3x limit → penalti (turunkan refillRate sementara)
		if est > float64(cfg.Server.RateLimiter.Limit*3) {
			// turunkan kapasitas refill untuk IP ini
			redisClient.Set(ctx, fmt.Sprintf("penalty:%s", ip), "1", 5*time.Minute)
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{"error": "adaptive block triggered"})
		}

		return c.Next()
	}
}
