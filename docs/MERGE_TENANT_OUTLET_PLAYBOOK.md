# Merge Playbook (Tenant/Outlet)

**Lihat juga:** [DATABASE_OVERVIEW.md](./DATABASE_OVERVIEW.md) §10 (konsep merge), [DATABASE_SCHEMA_CATALOG.md](./DATABASE_SCHEMA_CATALOG.md) §10 (tabel `merge_*`), [README.md](./README.md).

This playbook defines how to support two merge cases:

1. **Merchant-to-merchant merge**: all data from tenant A is merged into tenant B.
2. **Outlet-to-merchant merge**: only one outlet from tenant A is moved/merged into tenant B.

---

## 1) Supported Database Objects

Orchestration tables:
- `merge_requests`
- `merge_checkpoints`
- `merge_entity_mappings`

These tables are designed for:
- dry-run validation
- execution tracking
- mapping old IDs to new IDs
- post-merge audit and rollback traceability

---

## 2) Scope Types

`merge_requests.scope_type`:
- `1` = `MERCHANT_TO_MERCHANT`
- `2` = `OUTLET_TO_MERCHANT`

`merge_requests.run_mode`:
- `1` = `DRY_RUN`
- `2` = `EXECUTE`

`merge_requests.status`:
- `1` = REQUESTED
- `2` = APPROVED
- `3` = RUNNING
- `4` = COMPLETED
- `5` = FAILED
- `6` = ROLLED_BACK
- `7` = CANCELLED

---

## 3) Validation Rules (before execute)

### Common
- Source and target merchants must exist.
- Source and target must not be the same merchant.
- Request must be approved before execution.
- No other RUNNING merge for same source merchant.

### Case A: Merchant -> Merchant
- `source_outlet_id` should be NULL.
- `target_outlet_id` can be NULL (depends on merge strategy).
- Validate no conflicting unique keys that can break migration (SKU, etc).

### Case B: Outlet -> Merchant
- `source_outlet_id` is required.
- Source outlet must belong to source merchant.
- If `target_outlet_id` is set, it must belong to target merchant.
- If `target_outlet_id` is NULL, define strategy:
  - create new outlet in target merchant, or
  - re-parent source outlet to target merchant.

---

## 4) Execution Strategy

Recommended: checkpoint-based execution in a DB transaction per step.

Typical checkpoints:
1. `validate`
2. `lock_scope`
3. `move_reference_data` (products/variants/prices/etc as needed)
4. `move_operational_data` (customers, tagihan, transactions if in scope)
5. `move_billing_context` (if merchant-level merge and policy allows)
6. `recompute_entitlements_and_usage`
7. `finalize_and_mark_source`

Use `merge_entity_mappings` for each entity moved:
- `entity_type`, `source_id`, `target_id`

---

## 5) Two Case Implementations

### A) Merchant A -> Merchant B

Options:
- **Absorb**: reassign all `merchant_id` rows from A to B where allowed.
- **Consolidate**: migrate data to new entities under B and map old IDs.

After success:
- mark merchant A as suspended/merged (do not hard delete)
- keep audit/history intact

### B) Outlet A1 (from Merchant A) -> Merchant B

Options:
- **Re-parent outlet**: update `outlets.merchant_id` to B, then move dependent records scoped by outlet.
- **Clone + map**: create new outlet in B, copy/move data selectively, keep mapping.

After success:
- source merchant A remains active
- only selected outlet scope is moved

---

## 6) Security & RLS Notes

Merge is a privileged operation and may touch cross-tenant records.
Run merge executor with controlled elevated privilege and strict audit.

Every merge action should write to:
- `audit_log` (`action_type='MERGE_EXECUTE'`, `entity_type='merge_requests'`)
- include request ID, actor, and checkpoint summary.

---

## 7) Example Request Rows

Merchant merge (dry-run):
```sql
INSERT INTO merge_requests (
  id, scope_type, source_merchant_id, target_merchant_id, run_mode, status, requested_by_user_id, reason
) VALUES (
  'f1000000-0000-0000-0000-000000000001',
  1,
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  1,
  1,
  '22222222-2222-2222-2222-222222222222',
  'Consolidation after acquisition'
);
```

Outlet-only merge:
```sql
INSERT INTO merge_requests (
  id, scope_type, source_merchant_id, source_outlet_id, target_merchant_id, target_outlet_id, run_mode, status, requested_by_user_id, reason
) VALUES (
  'f1000000-0000-0000-0000-000000000002',
  2,
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  'dddddddd-dddd-dddd-dddd-dddddddddddd',
  1,
  1,
  '22222222-2222-2222-2222-222222222222',
  'Move one branch only'
);
```

