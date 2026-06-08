---
name: database-migration
description: Guidance for writing safe, reversible database schema migrations.
---
# Skill: Write Database Migration

## Purpose
Produce a safe, reviewable, and reversible database schema change that can be deployed without downtime or data loss.

## Prerequisites
- Data model change is defined in the technical design.
- ORM/migration tool is specified in `TECH.md`.

## Checklist
1.  **One change per migration**: Don't bundle unrelated schema changes. Name it clearly.
2.  **Always provide a rollback**: The change must be reversible.
3.  **Non-nullable columns**: Must have a `DEFAULT` value or a backfill step.
4.  **Renaming**: Use a multi-step expand-migrate-contract pattern. Do not rename and deploy in a single step.
5.  **Index creation**: Use `CONCURRENTLY` (PostgreSQL) or equivalent to avoid table locks.
6.  **Backfills**: Run in batches. Separate data migrations from schema migrations.
7.  **Testing**: Run the migration and its rollback locally before committing. Verify the schema diff and check for data loss.

## Quality Bar
- Migration and rollback apply cleanly.
- No data loss occurs.
- CI runs the migration during the test pipeline.
