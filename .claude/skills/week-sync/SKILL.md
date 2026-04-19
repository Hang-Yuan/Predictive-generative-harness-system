---
name: week-sync
description: Focus Zone state sync. Auto-called at startup step 6 every session. Two tiers by day of week: Mon-Thu lightweight sync, Fri-Sun deep backtrack. Both include continuity check.
---

# week-sync

Focus Zone state sync authority source. Auto-called by `CLAUDE.md §B startup sequence` step 6 every session.

## Loading Chain

**Upstream**: `CLAUDE.md §B startup sequence` step 6 — auto-called every session.

**Downstream**: `<ASSISTANT_ROOT>/00 Focus Zone/_本周.md` (write task markers during deep backtrack)

---

## Sunday Special Check (execute before either tier)

If today is **Sunday**:

1. Check if `_本周.md` already has `### 本周产出` section
2. **Has it** → weekly review already done, proceed with normal sync
3. **Doesn't have it** → append at end of sync report: "Today is Sunday, weekly review hasn't been done yet. Want to start now?" (wait for user response, don't auto-trigger)

---

## Both Tiers Include: Continuity Check (must execute every time)

At the end of sync report, execute continuity check:

1. Read `_本周.md` progress records, find **most recent date with substantive work** (skip blank days)
2. From that date section, extract all work segments':
   - Project names
   - File lists from "Related:" fields
3. Append continuity prompt at report end:

```
---
**Last worked** (YYYY-MM-DD):
- [Project name]: [what was done that day, one sentence]
  → Related files: [file1] · [file2]

To continue, tell me and I'll read the related files and give you a summary.
```

> If user's first message is "continue" / "pick up where we left off" etc., directly read related files and give full summary without waiting for confirmation.

---

## Lightweight Sync (Monday to Thursday)

1. Read `_本周.md`, confirm current week, task list, and progress records
2. Brief user: what day of the week, task completion status (X/N done), one-sentence recent progress summary
3. Execute continuity check (see above)
4. Don't modify files, don't ask for details

---

## Deep Backtrack (Friday to Sunday)

Core logic: **Identify active projects from `_本周.md` progress records, scan active project folders to discover unrecorded files, then cross-check task status.**

1. **Read `_本周.md` full text**, extract:
   - Task list: all tasks and completion status
   - Progress records: identify active project paths + recorded file names from each day's "Related:" fields
   - Week start date (from frontmatter `dates` field)

2. **Identify active projects**: extract project names under `01 Projects/` from related fields

3. **Diff scan (discover unrecorded files)**:
   - Scan each active project folder, collect `.md` files with **modification time ≥ week start date**
   - Exclude: `_归档/`, `_概览.md`, `文献记录.md` and other non-work-output files
   - **Diff** = files modified this week - file names already recorded in related fields
   - For each diff file, read first 30 lines to understand content and purpose

4. **Load active project overviews**: for each active project, read `_概览.md` for current status

5. **Cross-check task completion**:
   - Compare task list, identify "has progress in records but not marked complete in task list" items

6. **Update `_本周.md`** (silent write):
   - Mark clearly completed items as done (only mark definitively completed ones)
   - Mark uncertain ones as "pending confirmation"

7. **Report to user**:
   - Which projects were active this week, where each progressed to
   - **Diff files**: discovered unrecorded files, inferred content, suggest adding to progress records (don't auto-write, date attribution confirmed by user)
   - What task statuses were updated
   - Pending confirmation items
   - Execute continuity check (see above)

> **Core principle: use actual modifications in active project folders as ground truth, discover unrecorded files; use related fields as index, targeted loading of active projects, don't scan entire library.**
