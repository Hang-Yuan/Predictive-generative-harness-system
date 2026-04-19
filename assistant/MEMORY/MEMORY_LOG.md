---
title: Memory System Log
type: runtime-log
purpose: Memory system metabolism records (procedural/semantic candidate pool change log + memory weekly reviews)
version: 3.0
---

# Memory System Log

## Loading Chain

**Upstream:**
Not in startup must-load sequence. Loaded on demand (when auditing memory operation history); written by daily-review step 6 / weekly-review step 7.

**Related:**
- `00.memory_agent.md` — write format / metabolism rules / judgment anchors (rule authority)
- `procedural_memory.md` / `semantic_memory.md` — MEMORY_LOG records metabolism log; the two candidate pool files store current entries
- `ITERATION_LOG.md` — architecture/skill/protocol/persona changes go to ITERATION_LOG (versioned detailed entries), MEMORY_LOG only handles memory metabolism
- `LTM.md` — current situation snapshot + cross-week work nodes + weekly work review go to LTM, MEMORY_LOG only handles memory system itself

---

## About This File

**Memory log** only tracks **candidate pool metabolism**—procedural/semantic entry additions/star upgrades/downgrades/graduations/deletions, plus weekly memory system reviews.

**When to write:**
- Any session with candidate pool changes → append one line to `§操作日志` tail
- After weekly review completion → append complete weekly review entry to `§周复盘` tail

**Format:**
- Operation log: one brief line (`YYYY-MM-DD | [type]: [brief description]`), **no ## prefix**
- Weekly review: H3 heading (`### YYYY-WNN Weekly Review (YYYY-MM-DD)`), template in weekly-review skill

---

## Mechanism Quick Reference (v3 schema prediction)

| Mechanism | Description |
|---|---|
| Entry | High (match+deviant)→★★★; Medium (no match)→★; Low (match+expected)→don't write |
| Star upgrade | Same-direction re-observation → star +1 |
| Downgrade / dormant | weekly-review scan: N weeks no match → -1 star; 0 stars then continued no match → delete |
| Graduation (★★★★★) | Procedural → `SOUL/persona/persona_SOUL.md`; Semantic → `USER/USER.md`; must pass weekly-review confirmation + cross-week stability |
| Conflict | New entry contradicts existing → N-level inform user, don't silently overwrite |

---

## 操作日志

(Entries will be appended here as memory metabolism occurs.)

---

## 周复盘

(Weekly review entries will be appended here.)
