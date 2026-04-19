---
title: LTM.md
type: long-term-memory
description: Long-term work memory—current situation (top snapshot) + timeline (one row per week index) + detailed weekly records (by project, with file pointers)
version: 2.0
created: YYYY-MM-DD
---

# Long-Term Memory (LTM)

Cross-week work memory authority source. Four-layer structure: **Current Situation** (top snapshot: main/secondary priorities + major projects + transition predictions) → **Timeline** (one row per week index, new→old) → **Detailed Weekly Records** (by project, old→new append) → Archive files (complete discussion process).

---

## Loading Chain

**Upstream:**
`CLAUDE.md §B startup sequence` — read `§当前处境` + `§时间轴` every session (step 4); specific weekly records expanded on demand.

**Related:**
- `MEMORY/` — MEMORY handles L2/L3 memory entries; current situation snapshot lives at top of this file
- `00 Focus Zone/_本周.md` — this week's progress in _本周.md, cross-week nodes and current situation in LTM
- `MEMORY/MEMORY_LOG.md` — memory metabolism goes to MEMORY_LOG, work memory goes to LTM

---

## 当前处境

> Snapshot section. Main priorities / secondary priorities / major projects / transition predictions / last unresolved. S-level, direct overwrite, not historical record.

- **Main priority**: [Your current main focus/challenge]
- **Secondary priorities**: [Other ongoing concerns]
- **Major projects**:
  1. [Project 1 — current status summary]
  2. [Project 2 — current status summary]
- **Transition prediction**: [What's likely to shift next]
- **Last unresolved**: [Open items from last session]

**Write triggers**:
- User says "update situation" or similar
- Conversation reveals obvious phase transition (main priority changes)
- New conversation starts and this section is outdated

**Don't write**: Specific task progress (project files' job); emotional state (persona memory's job).

---

## 时间轴

> Index table. One row per week, new→old order. Read top N rows for recent overview.

| Week | Date Range | Summary | Archive Link |
|------|-----------|---------|-------------|
| | | | |

---

## 详细周录

> Detailed records. One section per week, old→new order (newest always at file bottom). Each section: by project with file pointers + key insights.

(Weekly detail sections will be appended here after each weekly review.)
