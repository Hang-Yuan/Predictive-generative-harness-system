---
name: weekly-review
description: Weekly review workflow. Trigger conditions: (1) Sunday daily-review step 6.5 auto-call; (2) week-sync Sunday detection prompts if not done; (3) User says "review", "weekly review", "summarize this week", etc.
---

# weekly-review

Weekly review workflow authority source. After review completion, auto-execute weekly archival (no need to ask).

## Trigger Mechanism

| Method | When | Who triggers |
|--------|------|-------------|
| Auto trigger | Sunday daily-review step 6.5 | daily-review calls at farewell |
| Startup prompt | Sunday week-sync detects not done | week-sync prompts at session start |
| Manual trigger | Any time | User says trigger words |

> **Must complete once every Sunday**. If Sunday session ends without doing it, daily-review step 6.5 forces trigger.

---

## Loading Chain

**Upstream**: daily-review step 6.5 (Sunday auto) / week-sync Sunday detection / user trigger

**Downstream**:
- `<ASSISTANT_ROOT>/00 Focus Zone/_本周.md` (write weekly output section + archive)
- `<ASSISTANT_ROOT>/MEMORY/procedural_memory.md` (procedural layer strength adjustment, decay, graduation)
- `<ASSISTANT_ROOT>/MEMORY/semantic_memory.md` (semantic layer strength adjustment, decay, graduation)
- `<ASSISTANT_ROOT>/MEMORY/MEMORY_LOG.md` (write complete weekly review entry)
- `<ASSISTANT_ROOT>/LTM.md` (§当前处境 overwrite + §时间轴 top insert + §详细周录 tail append)
- `<ASSISTANT_ROOT>/USER/USER.md` (semantic graduation write, requires C-level confirmation)
- `<ASSISTANT_ROOT>/SOUL/persona/persona_SOUL.md` (procedural graduation write, requires C-level confirmation)

---

## Preparation (load before executing)

Before executing any steps:
1. Read `_本周.md` full text (task list + progress records)
2. Read `LTM.md §当前处境` + `§时间轴` (current situation snapshot + cross-week overview)
3. Read `MEMORY/procedural_memory.md` + `MEMORY/semantic_memory.md` full text (all candidate pool entries)
4. Read `MEMORY/MEMORY_LOG.md` last 20 lines (recent memory metabolism)
5. From `_本周.md` task list, identify active projects, read each project's `_概览.md` current status

---

## Review Workflow (strict order)

### Step 1 · Panoramic Summary

Generate a complete weekly panoramic report from `_本周.md` progress records:

**Must cover these dimensions**:
- **Task completion**: against task list—what's checked off, what's untouched, what's newly added
- **Core advances**: most important theoretical/research/project advances this week (3-5 items, one sentence each)
- **Key outputs**: files created or substantially updated this week (what significance, not a list)
- **Key decisions**: framework-level choices or directional judgments made this week
- **Cross-project connections**: identify cross-project reasoning continuity (don't report by project independently)
- **Unexpected gains**: important things accomplished or discovered without planning
- **Remaining incomplete**: tasks not started or not finished, whether to carry to next week

Present this panorama to user, then continue to step 2.

---

### Step 2 · Give User Space

After panoramic summary, say:

"That's this week's panorama. Is there anything particularly important—events, shifts, or your own feelings—you'd like to share first?"

Wait for user input. Incorporate into subsequent steps (don't guide, don't ask specific questions first).

---

### Step 3 · Main Thread Alignment Check

Compare this week's work against `LTM.md §当前处境` (main priorities / secondary priorities / major projects / transition predictions):

1. **Alignment**: Did this week's work advance the main priority? How much?
2. **Deviation**: Did significant time go to non-main-thread work (ad hoc tasks, side explorations)? Worth it?
3. **Situation change**: After this week, does LTM.md §当前处境 need updating?
   - Changed → overwrite update (direct write, S-level)
   - No change → skip

---

### Step 3.5 · Episodic Pattern Extraction (episodic→schema, sole system channel)

**Purpose**: Extract **cross-day recurring intrinsic patterns** from this week's episodic stream into candidate entries for metabolism. Execution Mode real-time writes and daily-review daily scans are the first two safety nets; weekly-review is the third.

**Input**: `_本周.md §进展记录` full text + AI-flagged candidates not yet in pool.

**Observation Granularity Filter (pre-screen)**:

| Type | Example | Handling |
|---|---|---|
| **Specific idea** | "User thinks component X should be Y" | **Don't enter candidate pool**, goes to project main doc / episodic layer |
| **Intrinsic pattern** | "User defines boundaries first then converges when building theories" | **Can enter candidate pool** P / S |

Judgment scale: Will this still be true a year from now? Content-dependent→no; points to approach/methodology/behavior pattern→yes.

**Three Scan Questions** (categorized by layer):

| Layer | Scan Question | Pool Direction |
|---|---|---|
| **P (Procedural)** | Was AI corrected on anything this week? Same type of error across days/contexts? | `procedural_memory.md` |
| **S (Semantic)** | Did user show recurring **approach/methodology/value judgment** patterns in thinking/decision-making? | `semantic_memory.md` |
| **E (Episodic)** | Any stage conclusions or open questions to preserve? | Project main doc / LTM §详细周录 · do not elevate to candidate pool |

**Star Ladder (same-direction repeat observations)**:

| Same-direction observations this week | Entry/upgrade |
|---|---|
| 2 times | ★ (new or keep existing ★) |
| 3 times | ★★ (new ★★ or existing ★→★★) |
| Cross-week recurrence (existing entry hit again this week) | Per §M.2 upgrade rules |

**Dedup**: Search each candidate against existing entries in `procedural_memory.md` / `semantic_memory.md`. Found → append evidence + upgrade star; Not found → create new, star per ladder.

**Output**: Candidate entry list (N-level inform user), merged in step 4 review.

---

### Step 4 · Candidate Pool Entry Review

Review ALL entries in `procedural_memory.md` (procedural) and `semantic_memory.md` (semantic) one by one:

**Activation check**:
- Entries referenced, validated, or reinforced this week → reset decay timer

**Decay check** (entries >4 weeks since discovery or last reference):

| Current Stars | Decay Handling |
|---|---|
| **★★★★★** | Not in this flow (graduation trigger, step 6) |
| **★★★★** | Ask user "Is this memory still valid?" (approaching graduation, be careful) |
| **★★★** | Ask user "Is this memory still valid?" (don't force downgrade) |
| **★★** | Silently downgrade to ★ |
| **★** | Ask "Can this be deleted, or keep?" (delete/downgrade/keep) |

**New candidate merge**:
- Step 3.5 extraction output merged into formal flow here
- daily-review flagged but insufficiently verified P/S signals—decide here whether to upgrade

---

### Step 5 · Strength Adjustment Execution

Based on step 3.5 + step 4 review results, execute strength adjustments uniformly, write to corresponding candidate pool files (`procedural_memory.md` / `semantic_memory.md`, S-level, direct write).

---

### Step 6 · Graduation Check

Scan both candidate pool files for all entries at **★★★★★**. ★★★★★ is the auto-graduation trigger strength.

**Graduation paths** (by layer):

| Layer | Graduation Destination | Notes |
|---|---|---|
| **Semantic** (preferences / cognitive frameworks / value judgments) | `USER/USER.md` | Stable user identity fact, write to user world model |
| **Procedural** (situation→action patterns) | `SOUL/persona/persona_SOUL.md` | Stable AI behavior pattern, write to persona identity layer |

For each entry meeting graduation criteria:
1. Determine graduation path (semantic / procedural)
2. C-level confirmation: report graduation destination to user, wait for per-entry confirmation
3. After confirmation, write to destination
4. Mark original candidate pool entry `graduated → [destination] (YYYY-MM-DD)`, preserve audit trail, exclude from decay
5. Append graduation log to `MEMORY_LOG.md §操作日志`: `YYYY-MM-DD | Graduation: [entry name] → [destination]`

---

### Step 7 · Write MEMORY_LOG Weekly Review Entry

Append to `MEMORY_LOG.md §周复盘` section **tail** (H3 heading, old-to-new order, newest always at file bottom). This entry **only records memory system metabolism**, not work progress (work goes to LTM §详细周录).

Template:

```
### YYYY-WNN Weekly Review (YYYY-MM-DD)

**This week's memory operations**:
- Semantic new: [entry names] (or "none")
- Procedural new: [entry names] (or "none")
- Episodic→schema extraction: [entries extracted from episodic to candidate pool] (or "none")
- Corrections: [entry name old→new] (or "none")
- Deletions: [entry name and reason] (or "none")
- Graduations: [entry name and destination] (or "none")

**Strength changes**:
- Upgrades: [entry name ★→★★ etc.] (or "none")
- Downgrades: [entry name ★★→★ etc.] (or "none")

**Decay handling**: [which entries >4 weeks unreferenced were processed, or "none"]

**Review findings**: [issues, patterns, improvements found in memory system operation, or "none"]

**Next week iteration actions**: [memory system level adjustments for next week, or "none"]

**Parameter adjustments**: [decay period/surprise threshold/star ladder parameter changes, or "none"]
```

---

### Step 7.5 · Write ITERATION_LOG (conditional)

Condition: This week had any architecture-level change (new skill, workflow change, parameter adjustment, architecture restructuring, protocol iteration).

Met → append versioned entry to `ITERATION_LOG.md`.
Not met → skip.

---

After review workflow completes, immediately execute archival:

**8a · Write Weekly Output Section**
Append to `_本周.md` progress records tail:
```markdown
### 本周产出

[List actual outputs by project/category, one per line: `- filename.md — description`]
```

**8b · Archive Current Week File**
1. Rename/move `_本周.md` to `_归档/YYYY-Wnn.md` (Wnn from frontmatter `week` field)
2. Insert current week row at **top** of `LTM.md §时间轴` (timeline is new→old index): `| YYYY-Wnn | date range | one-sentence summary | [_归档/YYYY-Wnn.md] |`
3. Append current week detailed record at `LTM.md §详细周录` section **tail** (detailed records are old→new, newest always at file bottom):
   ```markdown
   ## Wnn · Detailed Weekly Record (YYYY-MM-DD ~ YYYY-MM-DD)

   - **Project1** — [core advance this week, one paragraph] → `file pointer`
   - **Project2** — [core advance this week, one paragraph] → `file pointer`

   - **Key insights**: [cross-project reasoning continuity, if any]
   ```

**8c · Create New Week File**
Create new `_本周.md` using standard template:
```markdown
---
title: This Week
week: "YYYY-Wnn"
dates: "YYYY-MM-DD ~ YYYY-MM-DD"
status: active
created: YYYY-MM-DD
---

# This Week

## Loading Chain

**Upstream:**
`CLAUDE.md §B startup sequence` — read every session (step 5).

**Related:**
- `00 Focus Zone/_归档/` — weekend archival target directory

---

## Raw Notes

Paste or dictate your raw thoughts here. This is your unfiltered thinking space. AI will not edit this block—your intentions, questions, and half-formed ideas are preserved in raw form.

---

## Task List

### This Week's Tasks

---

## Progress Records

> Each work segment format: **Project name** (path) / Related: file list / journal text

```

**8d · Archival Completion Report**
Tell user: "Archival complete. YYYY-Wnn has been stored in _归档/, new week file _本周.md has been created."

---

## Notes

- Steps 1-2 give user full space to speak, don't rush to calibrate
- Decay check must be thorough, don't miss entries
- Step 8 archival needs no confirmation, it's part of the review workflow
- If user says "don't archive yet" mid-process, note but skip step 8 this time, force on next Sunday
