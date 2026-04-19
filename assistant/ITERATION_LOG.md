---
title: Agent Architecture Change Log
type: agent-changelog
version: 1.0
last_updated: YYYY-MM-DD
---

# Agent Architecture Change Log

## Loading Chain

**Upstream:**
Authority source. Written during daily-review step 6b and weekly-review step 7.5. Major changes can be appended immediately.

**Related:**
- `LTM.md` — current situation + cross-week work nodes + weekly work review go to LTM, ITERATION_LOG doesn't record work progress.
- `MEMORY/MEMORY_LOG.md` — MEMORY_LOG only handles memory system metabolism (candidate pool changes + memory weekly reviews), ITERATION_LOG handles all architecture-level changes. No overlap.

---

## About This File

**Iteration log** tracks meaningful changes to the Agent system itself—not your work content, but how the AI thinks, what new skills it learned, workflow adjustments, parameter changes, and lessons learned.

**What to record (authority source, all architecture-level changes go here):**
- System architecture changes (file structure / protocol rules / inheritance chain / loading chain)
- Skill creation / rewrite / deprecation
- Workflow changes
- Parameter adjustments
- Persona file changes
- Memory system protocol iterations
- Hook script rewrites
- Major document version updates

**What NOT to record:**
- Daily work progress (in `_本周.md` progress records)
- Cross-week work nodes (in `LTM.md` detailed weekly records)
- Memory entry changes (in `MEMORY_LOG.md §操作日志`)
- Memory weekly reviews (in `MEMORY_LOG.md §周复盘`)

---

## Version Number Rules

Semantic versioning: `vMajor.Minor.Patch`

- **Major** (X.0.0): Breaking changes to architecture or core workflow
- **Minor** (0.X.0): New features/skills, parameter adjustments, workflow extensions
- **Patch** (0.0.X): Bug fixes, documentation clarifications, small optimizations

---

## 变更记录

(Versioned change entries will be appended here, old→new order, newest always at file bottom.)
