-- 000074_merge_orchestration.down.sql

BEGIN;

DROP TABLE IF EXISTS merge_entity_mappings;
DROP TABLE IF EXISTS merge_checkpoints;
DROP TABLE IF EXISTS merge_requests;

COMMIT;

