---
name: daily-review
description: End-of-session review workflow. Triggered by farewell phrases (good night / that's all for today). Complete the full review before responding to goodbye.
---

# daily-review

End-of-session review workflow authority source. session_end.sh detects farewell phrases and injects trigger signal, AI executes this workflow.

---

## Output Rules

**All output as natural conversation paragraphs, no step numbers, no step titles, no workflow labels.** Step numbers are internal execution order reference only, invisible in conversation.

---

## Review Workflow (strict order, no skipping)

### Step 1 · Scan P/S signals + Pattern detection

#### 1a. P/S Signal Write

Scan complete conversation, identify all P/S signals, then write:

- **P class** (situation→action patterns) → write to `MEMORY/procedural_memory.md`
- **S class** (user's cognitive frameworks/positions/work methods/preferences/value judgments) → write to `MEMORY/semantic_memory.md`

**Must deduplicate before writing (check each signal)**:
1. Check if corresponding candidate pool file already has similar entry
2. **Has similar entry** → upgrade strength (★→★★→…→★★★★★), append evidence, don't create new
3. **No similar entry** → create new, initial strength ★

**Relationship with Execution Mode**: High surprise P/S entries during conversation have already been written in real-time (★★★). This step is a **catch-all scan**—picking up missed Medium surprise signals, and dedup/star-upgrade review for already-pooled entries.

#### 1b. Pattern Detection (Learning Loop)

Scan this conversation for repeated operation patterns (not limited to correction signals):
- A query/organize/format action done 2+ times in this conversation
- Or highly matching an existing procedural layer entry's context

Matches existing entry → upgrade that entry by one star.
New pattern not in candidate pool → create new ★ entry.

#### 1c. Graduation Candidate Marking

After upgrade check: if any entry reaches ★★★★★ → **do NOT execute graduation here**, only annotate `[graduation candidate]` next to the entry.

> Graduation execution authority belongs to weekly-review step 6 (sole entry point). daily-review can nominate, upgrade stars, mark candidates, but CANNOT write to USER.md / persona_SOUL.md.

> No signals → skip.

---

### Step 2 · Scan E-class signals (C-level, write after confirmation)

Scan if this conversation produced E-class signals (episodic layer).

**E-class signal criteria**: conclusion established / open question clarified / stage decision / framework update

**If E-class signals exist**, generate confirmation table, wait for user confirmation before writing:

| Signal | Content Summary | Suggested Write Location | Confirm? |
|--------|----------------|--------------------------|----------|
| [conclusion/open/decision/framework] | [one sentence] | [project main doc §section / research record / literature record] | ✓ / skip |

Wait for user confirmation. User says "skip" or no response → skip entirely.

**E-class write location** (determined by current work context):
- Currently in `01 Projects/[X]` → that project's main doc corresponding section
- Currently in `02 Reading/[Y]` → that note / reading record file
- Currently in `03 Writing/[Z]` → that work's corresponding section
- Cross-context general conclusion → LTM.md §当前处境 or `_本周.md`

**Cross-project pointers (C-level confirmation)**: If an E-class conclusion affects multiple projects, write to authority location, then list affected projects in confirmation table for user approval. Only add pointers (`→ Authority source: [ProjectX/main-doc §section]`) in those projects. Do not copy conclusion content, only pointers.

**No unauthorized modification of project files.**

No E-class signals → skip.

---

### Step 3 · Update LTM.md current situation

Condition: This conversation had substantive change in main priorities or project status.

Has change → overwrite `LTM.md §当前处境` (S-level, direct write).
No change → skip.

---

### Step 4 · Write _本周.md today's progress

Append today's work segment to `_本周.md §进展记录` (S-level, direct write).

**Date section**: Find or create today's date section `### DayOfWeek YYYY-MM-DD`.

**Each work segment format** (one per project worked on):

```markdown
**Project Name** (`project root path`)
Related: `file1.md` · `file2.md`

- What was done today (journal style, no theoretical derivation details)
- What decisions were made
- What was completed, progress status
```

> `Related:` field is the anchor point for continuity checks. Must accurately list files actually modified or deeply read in this session.

---

### Step 5 · (Deprecated)

Skip.

---

### Step 6 · Write MEMORY_LOG.md (conditional)

Condition: This session had **memory system metabolism**:
- Candidate pool entry changes (new / correction / deletion / star upgrade / star downgrade)

Met → append record to `MEMORY_LOG.md §操作日志` tail, format: `YYYY-MM-DD | [type]: [brief description]`.
Not met → skip.

---

### Step 6b · Write ITERATION_LOG.md (conditional)

Condition: This session had any **architecture-level change**:
- System architecture changes (file structure / protocol rules / inheritance chain / loading chain)
- Skill creation / rewrite / deprecation
- Persona file changes
- Memory system protocol iteration
- Hook script rewrites

Met → append versioned entry to `ITERATION_LOG.md §变更记录` tail (`vX.Y.Z · date · type`, with summary/details/impact/trigger/related).
Not met → skip.

---

### Step 6.5 · Weekly review (Sunday conditional trigger)

Condition: Today is **Sunday**.

Met → execute `weekly-review` skill full workflow.

> Authority source: `~/.claude/skills/weekly-review/SKILL.md`

Not met → skip.

---

### Step 7 · Respond to farewell

After all steps complete, respond to user's goodbye.

---

## Loading Chain

**Upstream trigger**: `~/.claude/hooks/session_end.sh` → detect farewell → inject additionalContext
**Downstream files**: `MEMORY/procedural_memory.md`, `MEMORY/semantic_memory.md`, `LTM.md`, `_本周.md`, `MEMORY_LOG.md`, `ITERATION_LOG.md`, weekly-review skill (Sunday trigger)
