-- Billing seed + gate query examples (production-style baseline)
-- Assumes migrations 000081..000084 are already applied.

BEGIN;

-- =========================================================
-- 1) PLAN CATALOG SEED
-- =========================================================

-- Plans
INSERT INTO billing_plans (id, code, name, description, is_active, trial_days, sort_order, metadata_json, created_at, updated_at)
VALUES
  ('a1111111-1111-1111-1111-111111111111', 'FREE', 'Free', 'Starter plan for micro merchants', TRUE, 14, 1, '{}'::jsonb, now(), now()),
  ('a2222222-2222-2222-2222-222222222222', 'PRO', 'Pro', 'Growing business plan', TRUE, 14, 2, '{}'::jsonb, now(), now()),
  ('a3333333-3333-3333-3333-333333333333', 'ENTERPRISE', 'Enterprise', 'Advanced plan for chain stores', TRUE, 0, 3, '{}'::jsonb, now(), now())
ON CONFLICT (id) DO NOTHING;

-- Monthly prices (IDR)
INSERT INTO billing_plan_prices (id, plan_id, currency, billing_interval, amount, is_active, effective_from, created_at, updated_at)
VALUES
  ('b1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'IDR', 1, 0, TRUE, now(), now(), now()),
  ('b2222222-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'IDR', 1, 149000, TRUE, now(), now(), now()),
  ('b3333333-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'IDR', 1, 499000, TRUE, now(), now(), now())
ON CONFLICT (id) DO NOTHING;

-- Feature bundle: FREE
INSERT INTO billing_plan_features (id, plan_id, feature_key, is_enabled, limit_value, metadata_json, created_at, updated_at)
VALUES
  ('c1000001-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'outlet_count', TRUE, 1, '{}'::jsonb, now(), now()),
  ('c1000002-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'active_user_count', TRUE, 2, '{}'::jsonb, now(), now()),
  ('c1000003-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'wa_automation', FALSE, NULL, '{}'::jsonb, now(), now()),
  ('c1000004-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'advanced_reporting', FALSE, NULL, '{}'::jsonb, now(), now()),
  ('c1000005-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'audit_log_export', FALSE, NULL, '{}'::jsonb, now(), now())
ON CONFLICT (plan_id, feature_key) DO NOTHING;

-- Feature bundle: PRO
INSERT INTO billing_plan_features (id, plan_id, feature_key, is_enabled, limit_value, metadata_json, created_at, updated_at)
VALUES
  ('c2000001-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'outlet_count', TRUE, 5, '{}'::jsonb, now(), now()),
  ('c2000002-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'active_user_count', TRUE, 20, '{}'::jsonb, now(), now()),
  ('c2000003-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'wa_automation', TRUE, 5000, '{"unit":"messages/month"}'::jsonb, now(), now()),
  ('c2000004-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'advanced_reporting', TRUE, NULL, '{}'::jsonb, now(), now()),
  ('c2000005-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222222', 'audit_log_export', TRUE, NULL, '{}'::jsonb, now(), now())
ON CONFLICT (plan_id, feature_key) DO NOTHING;

-- Feature bundle: ENTERPRISE
INSERT INTO billing_plan_features (id, plan_id, feature_key, is_enabled, limit_value, metadata_json, created_at, updated_at)
VALUES
  ('c3000001-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'outlet_count', TRUE, 1000, '{}'::jsonb, now(), now()),
  ('c3000002-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'active_user_count', TRUE, 10000, '{}'::jsonb, now(), now()),
  ('c3000003-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'wa_automation', TRUE, 1000000, '{"unit":"messages/month"}'::jsonb, now(), now()),
  ('c3000004-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'advanced_reporting', TRUE, NULL, '{}'::jsonb, now(), now()),
  ('c3000005-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'audit_log_export', TRUE, NULL, '{}'::jsonb, now(), now())
ON CONFLICT (plan_id, feature_key) DO NOTHING;

COMMIT;

-- =========================================================
-- 2) EXAMPLE: ACTIVATE SUBSCRIPTION FOR ONE MERCHANT
-- =========================================================
-- Replace merchant_id with real merchant if needed.

BEGIN;
SET LOCAL app.merchant_id = '11111111-1111-1111-1111-111111111111';

INSERT INTO merchant_subscriptions (
  id, merchant_id, plan_id, plan_price_id, status, auto_renew,
  started_at, current_period_start, current_period_end,
  trial_start, trial_end, metadata_json, created_at, updated_at
)
VALUES (
  'd1111111-1111-1111-1111-111111111111',
  '11111111-1111-1111-1111-111111111111',
  'a1111111-1111-1111-1111-111111111111', -- FREE
  'b1111111-1111-1111-1111-111111111111',
  2, -- active
  TRUE,
  now(),
  now(),
  now() + interval '30 days',
  now(),
  now() + interval '14 days',
  '{}'::jsonb,
  now(),
  now()
)
ON CONFLICT (id) DO NOTHING;

-- Cache effective entitlement snapshot (normally generated by service job)
INSERT INTO merchant_entitlements (
  id, merchant_id, feature_key, is_enabled, limit_value, source,
  effective_from, metadata_json, created_at, updated_at
)
SELECT
  gen_random_uuid(),
  '11111111-1111-1111-1111-111111111111'::uuid,
  f.feature_key,
  f.is_enabled,
  f.limit_value,
  'plan',
  now(),
  '{}'::jsonb,
  now(),
  now()
FROM billing_plan_features f
WHERE f.plan_id = 'a1111111-1111-1111-1111-111111111111'
  AND f.deleted_at IS NULL
ON CONFLICT DO NOTHING;

COMMIT;

-- =========================================================
-- 3) GATE QUERY: CAN MERCHANT CREATE NEW OUTLET?
-- =========================================================
-- Result columns:
-- - can_create_outlet (boolean)
-- - reason (text)
-- - active_outlets / outlet_limit for debugging

WITH entitlement AS (
  SELECT
    me.merchant_id,
    me.is_enabled,
    COALESCE(me.limit_value, 0) AS limit_value
  FROM merchant_entitlements me
  WHERE me.merchant_id = '11111111-1111-1111-1111-111111111111'::uuid
    AND me.feature_key = 'outlet_count'
    AND me.deleted_at IS NULL
    AND me.effective_to IS NULL
  ORDER BY me.effective_from DESC
  LIMIT 1
),
usage_outlets AS (
  SELECT
    o.merchant_id,
    COUNT(*)::bigint AS active_outlets
  FROM outlets o
  WHERE o.merchant_id = '11111111-1111-1111-1111-111111111111'::uuid
    AND o.deleted_at IS NULL
    AND o.is_deleted = FALSE
  GROUP BY o.merchant_id
)
SELECT
  CASE
    WHEN e.is_enabled IS DISTINCT FROM TRUE THEN FALSE
    WHEN e.limit_value = 0 THEN FALSE
    WHEN COALESCE(u.active_outlets, 0) < e.limit_value THEN TRUE
    ELSE FALSE
  END AS can_create_outlet,
  CASE
    WHEN e.is_enabled IS DISTINCT FROM TRUE THEN 'feature_disabled'
    WHEN e.limit_value = 0 THEN 'limit_zero'
    WHEN COALESCE(u.active_outlets, 0) >= e.limit_value THEN 'limit_reached'
    ELSE 'ok'
  END AS reason,
  COALESCE(u.active_outlets, 0) AS active_outlets,
  e.limit_value AS outlet_limit
FROM entitlement e
LEFT JOIN usage_outlets u
  ON u.merchant_id = e.merchant_id;

-- =========================================================
-- 4) GATE QUERY: CHECK FEATURE ACCESS (generic)
-- =========================================================
-- Replace :feature_key accordingly.
SELECT
  me.feature_key,
  me.is_enabled,
  me.limit_value,
  me.source,
  me.effective_from,
  me.effective_to
FROM merchant_entitlements me
WHERE me.merchant_id = '11111111-1111-1111-1111-111111111111'::uuid
  AND me.feature_key = 'wa_automation'
  AND me.deleted_at IS NULL
ORDER BY me.effective_from DESC
LIMIT 1;

