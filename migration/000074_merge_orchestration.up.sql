-- 000074_merge_orchestration.up.sql
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

COMMENT ON TABLE merge_requests IS 'Permintaan merge antar tenant atau satu outlet ke tenant lain (dry-run/execute); untuk admin/service.';
COMMENT ON TABLE merge_checkpoints IS 'Langkah eksekusi merge (checkpoint) untuk resume dan audit proses.';
COMMENT ON TABLE merge_entity_mappings IS 'Mapping ID sumber ke ID target per merge untuk jejak dan rollback.';

COMMENT ON COLUMN merge_requests.id IS 'Primary key permintaan merge.';
COMMENT ON COLUMN merge_requests.scope_type IS '1=merchant ke merchant; 2=outlet ke merchant.';
COMMENT ON COLUMN merge_requests.source_merchant_id IS 'Tenant sumber.';
COMMENT ON COLUMN merge_requests.source_outlet_id IS 'Cabang sumber jika scope outlet.';
COMMENT ON COLUMN merge_requests.target_merchant_id IS 'Tenant tujuan.';
COMMENT ON COLUMN merge_requests.target_outlet_id IS 'Cabang tujuan opsional.';
COMMENT ON COLUMN merge_requests.run_mode IS '1=dry-run; 2=eksekusi.';
COMMENT ON COLUMN merge_requests.status IS 'Alur: diminta, disetujui, jalan, selesai, gagal, rollback, batal.';
COMMENT ON COLUMN merge_requests.requested_by_user_id IS 'Pemohon.';
COMMENT ON COLUMN merge_requests.approved_by_user_id IS 'Penyetuju.';
COMMENT ON COLUMN merge_requests.executed_by_user_id IS 'Eksekutor.';
COMMENT ON COLUMN merge_requests.reason IS 'Alasan bisnis.';
COMMENT ON COLUMN merge_requests.dry_run_report IS 'Hasil validasi dry-run (JSON).';
COMMENT ON COLUMN merge_requests.execution_summary IS 'Ringkasan setelah jalan (JSON).';
COMMENT ON COLUMN merge_requests.error_message IS 'Pesan error jika gagal.';
COMMENT ON COLUMN merge_requests.requested_at IS 'Waktu permintaan.';
COMMENT ON COLUMN merge_requests.approved_at IS 'Waktu persetujuan.';
COMMENT ON COLUMN merge_requests.started_at IS 'Waktu mulai eksekusi.';
COMMENT ON COLUMN merge_requests.completed_at IS 'Waktu selesai.';
COMMENT ON COLUMN merge_requests.rolled_back_at IS 'Waktu rollback jika ada.';
COMMENT ON COLUMN merge_requests.created_at IS 'Waktu rekaman.';
COMMENT ON COLUMN merge_requests.updated_at IS 'Waktu pembaruan.';
COMMENT ON COLUMN merge_requests.deleted_at IS 'Soft delete.';

COMMENT ON COLUMN merge_checkpoints.id IS 'Primary key checkpoint.';
COMMENT ON COLUMN merge_checkpoints.merge_request_id IS 'Permintaan merge induk.';
COMMENT ON COLUMN merge_checkpoints.step_key IS 'Nama langkah (string).';
COMMENT ON COLUMN merge_checkpoints.status IS '1=menunggu; 2=jalan; 3=sukses; 4=gagal; 5=dilewati.';
COMMENT ON COLUMN merge_checkpoints.detail_json IS 'Detail eksekusi langkah.';
COMMENT ON COLUMN merge_checkpoints.started_at IS 'Mulai langkah.';
COMMENT ON COLUMN merge_checkpoints.completed_at IS 'Selesai langkah.';
COMMENT ON COLUMN merge_checkpoints.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN merge_checkpoints.updated_at IS 'Waktu pembaruan.';

COMMENT ON COLUMN merge_entity_mappings.id IS 'Primary key mapping.';
COMMENT ON COLUMN merge_entity_mappings.merge_request_id IS 'Permintaan merge.';
COMMENT ON COLUMN merge_entity_mappings.entity_type IS 'Jenis entitas (tabel/logis).';
COMMENT ON COLUMN merge_entity_mappings.source_id IS 'ID di sistem sumber.';
COMMENT ON COLUMN merge_entity_mappings.target_id IS 'ID di sistem tujuan.';
COMMENT ON COLUMN merge_entity_mappings.metadata_json IS 'Metadata.';
COMMENT ON COLUMN merge_entity_mappings.created_at IS 'Waktu pembuatan.';
COMMENT ON COLUMN merge_entity_mappings.updated_at IS 'Waktu pembaruan.';

COMMIT;

