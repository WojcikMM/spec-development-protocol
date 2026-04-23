---
description: Guidance for writing safe, reversible database schema migrations with consistent naming, rollback support, and zero data-loss defaults.
---
# Skill: Write Database Migration

## Purpose

Produce a safe, reviewable, and reversible database schema change that can be deployed incrementally without downtime or data loss.

## When to Use

- Adding, removing, or renaming a column, table, or index.
- Changing a column's type or constraints.
- Seeding reference/lookup data that belongs to the schema.
- Backfilling existing data as part of a schema change.

## Prerequisites

- [ ] The data model change is defined in the technical design (`docs/architecture/DESIGN-<slug>.md`).
- [ ] The ORM/migration tool is specified in `.github/TECH.md` section 3 (e.g., Prisma Migrate, TypeORM, Alembic, Flyway, Liquibase).
- [ ] The target environment's current schema state is known.

## Checklist

### Before Writing the Migration
1. **Read the current schema** — understand what exists before changing it.
2. **One migration = one logical change** — do not bundle unrelated schema changes in a single migration file.
3. **Name it clearly** — use a descriptive name: `add_email_verified_to_users`, `create_orders_table`, `drop_legacy_sessions`.

### Writing the Migration
4. **Always provide a rollback / down migration** — the change must be reversible without manual intervention.
5. **Non-nullable columns** — never add a `NOT NULL` column without a `DEFAULT` value or a backfill step. Adding a non-nullable column to a large table without a default will fail.
6. **Renaming** — never rename a column or table in a single migration while the application is live. Use a 3-step expand-migrate-contract pattern:
   - Step 1: Add the new column alongside the old one.
   - Step 2: Backfill and dual-write during deployment.
   - Step 3: Drop the old column in a later release.
7. **Index creation** — use `CREATE INDEX CONCURRENTLY` (PostgreSQL) or equivalent to avoid table locks in production.
8. **Backfill in batches** — never update all rows in a single `UPDATE` statement on large tables; use batch processing.
9. **Data migrations and schema migrations are separate** — do not mix DDL and large DML operations.

### Testing the Migration
10. **Run the migration against a local/dev database** before committing.
11. **Run the rollback** immediately after running the migration to confirm it works.
12. **Verify the schema diff** matches the intended change exactly.
13. **Check for data loss** — confirm no existing data is silently dropped or truncated.

### Review Checklist
- [ ] Migration is reversible (down/rollback migration exists and was tested).
- [ ] No `NOT NULL` column added without a default or backfill.
- [ ] No table-locking operations on tables with significant row counts.
- [ ] Migration name is descriptive and follows project naming conventions.
- [ ] Migration file is committed alongside the code change that requires it.

## Quality Bar

- Migration applies cleanly to a fresh database and an existing production-like database.
- Rollback applies cleanly after the migration.
- No data loss occurs for any row that existed before the migration.
- CI runs the migration as part of the test pipeline.

## Common Pitfalls

- **Non-nullable column without default** — causes migration to fail on non-empty tables.
- **Locking large tables** — adding an index without `CONCURRENTLY` can lock a table for minutes in production.
- **One-way migrations** — not writing the down migration until it's too late to roll back a bad deploy.
- **Bundling data backfill with schema changes** — slow backfills can time out or block schema application.
- **Renaming in one step** — breaking the running application before the new column is live.
