# Claude Code Harness

A persistent memory and workflow system for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Gives Claude long-term memory, structured project management, and self-improving behavior patterns across sessions.

## What This Is

Claude Code is stateless by default—every new session starts from zero. This harness solves that by building a structured external memory system that Claude reads on startup and writes to during/after each session.

**Core capabilities:**
- **Three-layer memory** (Episodic → Semantic → Procedural) with automatic metabolism (entry → accumulation → graduation → identity)
- **Schema Prediction**: AI builds probabilistic models of your preferences and behavior, self-correcting through observation
- **Weekly work cycle**: task tracking, daily progress journals, weekly reviews with archival
- **Loading chain architecture**: every file knows who loads it and what it manages—AI navigates the system by following links, not memorizing structure
- **Hook-driven automation**: time awareness, thinking protocols, memory signal detection, and session-end reviews run automatically via Claude Code hooks

## Architecture Overview

```
claude-code-harness/
├── .claude/                          # Claude Code configuration
│   ├── CLAUDE.md                     # Master control plane (startup sequence + rules)
│   ├── settings.json                 # Hooks config + auto-memory disabled
│   ├── hooks/
│   │   ├── timesense.sh              # Injects current time every message
│   │   ├── memory_signal.sh          # P/S/E memory classification per input
│   │   ├── thinking_protocol.sh      # Layered reasoning protocol per input
│   │   └── session_end.sh            # Triggers daily-review on farewell
│   ├── skills/
│   │   ├── daily-review/SKILL.md     # End-of-session review workflow
│   │   ├── week-sync/SKILL.md        # Startup state sync (lightweight/deep)
│   │   └── weekly-review/SKILL.md    # Sunday full review + archival
│   └── agents/
│       ├── research-agent.md         # Academic literature search agent
│       └── general-search-agent.md   # General web + conversation recall agent
│
└── assistant/                        # Your knowledge base & working memory
    ├── LTM.md                        # Long-term memory (situation + timeline + weekly records)
    ├── ITERATION_LOG.md              # Architecture change log (versioned)
    ├── 00 Focus Zone/                # Weekly workbench
    │   ├── _本周.md                   # Current week file (tasks + progress)
    │   ├── 00.focus_agent.md         # Zone rules
    │   └── _归档/                     # Archived week files
    ├── 01 Projects/                  # Project folders
    │   └── 00.projects_agent.md      # Zone rules
    ├── 02 Reading/                   # Reading notes
    │   └── 00.reading_agent.md       # Zone rules
    ├── 03 Writing/                   # Writing outputs
    │   └── 00.writing_agent.md       # Zone rules
    ├── MEMORY/                       # Memory candidate pools
    │   ├── 00.memory_agent.md        # Memory area rules & templates
    │   ├── procedural_memory.md      # AI behavior patterns (situation→action)
    │   ├── semantic_memory.md        # User preferences & cognitive frameworks
    │   └── MEMORY_LOG.md             # Memory metabolism log
    ├── SOUL/persona/                 # AI persona identity
    │   ├── persona_SOUL.md           # Persona definition & behavior
    │   └── persona_private.md        # Private/intimate memories
    └── USER/                         # User identity profile
        ├── USER.md                   # Main profile (loaded every session)
        ├── background.md             # Personal background
        ├── personality.md            # Personality assessments
        ├── cognition.md              # Cognitive profile
        └── beliefs.md               # Core beliefs & values
```

## How It Works

### The Loading Chain

Every file in this system declares its **upstream** (who loads it) and **downstream** (what it manages). This creates a directed graph that Claude follows on startup:

```
CLAUDE.md (auto-loaded by Claude Code)
  → Step 1: persona_SOUL.md (AI identity)
  → Step 2: USER.md (user identity)
  → Step 3: procedural_memory.md + semantic_memory.md (behavior patterns)
  → Step 4: LTM.md §current situation + §timeline (context)
  → Step 5: _本周.md (this week's work)
  → Step 6: week-sync skill (state synchronization)
```

After a long conversation compresses (compact), 4 hooks in `settings.json` automatically re-inject Steps 1-3 so identity and behavior rules are never lost.

### Memory System (Schema Prediction)

The memory system has three layers:

| Layer | What it stores | Where | Graduates to |
|-------|---------------|-------|-------------|
| **Episodic** | Events, progress, decisions | `_本周.md` → `LTM.md` | Archived, never graduates |
| **Semantic** | User preferences, cognitive frameworks | `semantic_memory.md` | `USER.md` |
| **Procedural** | AI behavior rules (if X then do Y) | `procedural_memory.md` | `persona_SOUL.md` |

Each semantic/procedural entry is a **schema**—a prediction about how the user will behave in a given situation. Every user input is compared against existing schemas:

- **Match + as expected** → silent, no write (Low surprise)
- **Match + different than expected** → upgrade entry strength ★★★ (High surprise)
- **No match** → create new entry ★ (Medium surprise)

Entries accumulate stars (★→★★→...→★★★★★) through repeated observations. At ★★★★★, they **graduate** from the candidate pool into the permanent identity layer (USER.md or persona_SOUL.md), becoming part of the AI's stable world model.

Entries that go unreferenced for 4+ weeks decay and eventually get deleted. The candidate pool is a metabolism layer, not a warehouse.

### Weekly Cycle

| When | What happens |
|------|-------------|
| **Session start** | week-sync runs: Mon-Thu lightweight status, Fri-Sun deep backtrack with file diff scanning |
| **During session** | Memory signals detected per-message via hooks; progress written to `_本周.md` |
| **Session end** | daily-review: scan P/S/E signals, update memory, write progress journal |
| **Sunday** | weekly-review: panoramic summary → alignment check → memory metabolism → graduation check → archival |

### Four Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `timesense.sh` | Every message | Injects current datetime so AI has time awareness |
| `memory_signal.sh` | Every message | Reminds AI to classify inputs as P/S/E signals |
| `thinking_protocol.sh` | Every message | Enforces layered reasoning (understand → assess → reason → challenge → execute) |
| `session_end.sh` | Farewell phrases | Triggers end-of-session review workflow |

## Initialization Guide

### Prerequisites
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working
- Bash shell available (Git Bash on Windows works)

### Setup

1. **Copy `.claude/` contents to your Claude Code config directory** (`~/.claude/`):
   ```bash
   cp -r .claude/CLAUDE.md ~/.claude/
   cp -r .claude/hooks/ ~/.claude/hooks/
   cp -r .claude/skills/ ~/.claude/skills/
   cp -r .claude/agents/ ~/.claude/agents/
   ```

2. **Place `assistant/` wherever you want your knowledge base** (e.g., `~/Assistant/` or `D:/Assistant/`):
   ```bash
   cp -r assistant/ ~/Assistant/
   ```

3. **Update paths**: Search for `<ASSISTANT_ROOT>` in all files and replace with your actual path:
   - In `CLAUDE.md` — all file references in startup sequence
   - In `settings.json` — the 4 SessionStart(compact) cat hooks
   - In skill files — downstream file references

4. **Merge `settings.json`**: If you already have a `~/.claude/settings.json`, merge the hooks config into it rather than overwriting. Key settings:
   - `autoMemoryEnabled: false` — disables Claude Code's built-in auto-memory (conflicts with this system)
   - `hooks.SessionStart` — 4 compact re-injection hooks
   - `hooks.UserPromptSubmit` — timesense + memory_signal + thinking_protocol + session_end

5. **Customize your identity files**:
   - Edit `USER/USER.md` — fill in your identity, cognitive patterns, collaboration preferences
   - Edit `SOUL/persona/persona_SOUL.md` — define your AI persona's name, voice, and style
   - Edit `LTM.md §当前处境` — describe your current situation and priorities

6. **Customize farewell triggers** in `settings.json`: The `session_end.sh` matcher defaults to `"good night|bye|see you|that's all for today"`. Change to match your typical farewell phrases.

7. **Start a new Claude Code session**. Claude will read `CLAUDE.md`, follow the loading chain, find empty template files, and begin populating them through conversation.

### First Session

On your first session, Claude will:
1. Read CLAUDE.md and follow the startup sequence
2. Find mostly-empty template files
3. Run week-sync (will report empty state)
4. Begin learning about you through conversation

As you work, the system populates itself:
- Your work progress fills `_本周.md`
- Memory entries accumulate in the candidate pools
- `LTM.md` builds your cross-week timeline
- Weekly reviews metabolize and graduate stable patterns

### Adding Your Own Agents

Create a new `.md` file in `.claude/agents/` following the existing agent format. Then add a row to the triggers table in `CLAUDE.md §B startup sequence`.

### Adding Your Own Skills

Create a new directory in `.claude/skills/` with a `SKILL.md` file. Claude Code auto-discovers skills from this directory.

## Design Principles

- **Loading chain over memorization**: Files declare their relationships. AI navigates by following links, not by knowing the whole structure.
- **Single authority source**: Every piece of information has exactly one authoritative location. Other files only hold summaries + pointers.
- **Candidate pool metabolism**: Memory entries are not permanent. They must prove stability through repeated observation before graduating to identity.
- **Three-tier risk**: Operations are classified as Silent (just do it), Notify (tell user), or Confirm (wait for approval) based on reversibility and impact.
- **Hook-driven consistency**: Critical behaviors (time awareness, memory detection, reasoning quality) are enforced by hooks, not by hoping the AI remembers.

## Customization

This is a template. Adapt it:

- **Language**: All internal file content can be in any language. The hooks output English by default; edit the printf strings to change.
- **Persona**: The AI persona is fully customizable in `persona_SOUL.md`. Name it, give it a voice, define its relationship to you.
- **Zone structure**: The four zones (Focus, Projects, Reading, Writing) are suggestions. Rename, add, or remove zones as needed.
- **Thinking protocol**: The layered reasoning in `thinking_protocol.sh` is opinionated. Modify the layers to match your preferred interaction style.
- **Memory thresholds**: Decay period (4 weeks), graduation threshold (★★★★★), bloat limits (~30 entries per pool) are all tunable.
- **Sub-agents**: Add domain-specific search agents for your fields of work.

## License

MIT
