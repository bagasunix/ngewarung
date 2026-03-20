-- 000085_merge_orchestration.up.sql
-- Orchestration tables for cross-tenant merge (merchant-level and outlet-level).
-- NOTE:
-- - This is intended for platform-admin/service execution.
-- - Merge execution should run under privileged role (or controlled bypass RLS),
--   because it may need to move data across merchants.

BEGIN;

CREATE TABLE IF NOT EXISTS merge_requests (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- 1=MERCHANT_TO_MERCHANT, 2=OUTLET_TO_MERCHANT
    scope_type            SMALLINT NOT NULL,

    source_merchant_id    UUID NOT NULL REFERENCES merchants(id) ON DELETE RESTRICT,
    source_outlet_id      UUID REFERENCES outlets(id) ON DELETE RESTRICT,
    target_merchant_id    UUID NOT NULL REFERENCES merchants(id) ON DELETE RESTRICT,
    target_outlet_id      UUID REFERENCES outlets(id) ON DELETE RESTRICT,

    -- 1=DRY_RUN, 2=EXECUTE
    run_mode              SMALLINT NOT NULL DEFAULT 1,
    -- 1=REQUESTED, 2=APPROVED, 3=RUNNING, 4=COMPLETED, 5=FAILED, 6=ROLLED_BACK, 7=CANCELLED
    status                SMALLINT NOT NULL DEFAULT 1,

    requested_by_user_id  UUID REFERENCES users(id) ON DELETE SET NULL,
    approved_by_user_id   UUID REFERENCES users(id) ON DELETE SET NULL,
    executed_by_user_id   UUID REFERENCES users(id) ON DELETE SET NULL,

    reason                TEXT,
    dry_run_report        JSONB,
    execution_summary     JSONB,
    error_message         TEXT,

    requested_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    approved_at           TIMESTAMPTZ,
    started_at            TIMESTAMPTZ,
    completed_at          TIMESTAMPTZ,
    rolled_back_at        TIMESTAMPTZ,

    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at            TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_merge_requests_status ON merge_requests(status);
CREATE INDEX IF NOT EXISTS idx_merge_requests_scope_type ON merge_requests(scope_type);
CREATE INDEX IF NOT EXISTS idx_merge_requests_source_merchant ON merge_requests(source_merchant_id);
CREATE INDEX IF NOT EXISTS idx_merge_requests_target_merchant ON merge_requests(target_merchant_id);

CREATE TABLE IF NOT EXISTS merge_checkpoints (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merge_request_id      UUID NOT NULL REFERENCES merge_requests(id) ON DELETE CASCADE,
    step_key              TEXT NOT NULL, -- e.g. validate, move_products, move_transactions, finalize
    -- 1=PENDING, 2=RUNNING, 3=SUCCESS, 4=FAILED, 5=SKIPPED
    status                SMALLINT NOT NULL DEFAULT 1,
    detail_json           JSONB,
    started_at            TIMESTAMPTZ,
    completed_at          TIMESTAMPTZ,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (merge_request_id, step_key)
);

CREATE INDEX IF NOT EXISTS idx_merge_checkpoints_request ON merge_checkpoints(merge_request_id);

-- Mapping source IDs to target IDs for traceability / rollback support.
CREATE TABLE IF NOT EXISTS merge_entity_mappings (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merge_request_id      UUID NOT NULL REFERENCES merge_requests(id) ON DELETE CASCADE,
    entity_type           TEXT NOT NULL, -- outlets, products, variants, customers, etc.
    source_id             TEXT NOT NULL,
    target_id             TEXT,
    metadata_json         JSONB,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (merge_request_id, entity_type, source_id)
);

CREATE INDEX IF NOT EXISTS idx_merge_entity_mappings_request ON merge_entity_mappings(merge_request_id);
CREATE INDEX IF NOT EXISTS idx_merge_entity_mappings_entity ON merge_entity_mappings(entity_type);

COMMIT;

