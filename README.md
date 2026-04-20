# Predictive Generative Harness System (PGH System)

一个为 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 设计的持久化记忆与工作流系统。赋予 Claude 跨会话的长期记忆、结构化项目管理和自我改进的行为模式。

## 这是什么

Claude Code 默认是无状态的——每个新会话从零开始。这套 harness 通过构建结构化的外部记忆系统解决这个问题：Claude 在启动时读取、在会话中和结束时写入。

**核心能力：**
- **三层记忆**（情景层 → 语义层 → 程序层），带自动代谢（入池 → 积累 → 毕业 → 身份层）
- **Schema Prediction**：AI 对用户偏好和行为构建概率性预测模型，通过观察自我修正
- **周工作循环**：任务追踪、每日进展日志、周复盘与归档
- **加载链架构**：每个文件声明上游（谁加载它）和下游（它管什么）——AI 通过跟随链接导航系统，而不是记忆整个结构
- **Hook 驱动自动化**：时间感知、思考协议、记忆信号检测、会话结束复盘，通过 Claude Code hooks 自动运行

## 架构概览

```
pgh-system/
├── .claude/                          # Claude Code 配置
│   ├── CLAUDE.md                     # 主控面板（启动序列 + 规则）
│   ├── settings.json                 # Hooks 配置 + 禁用自动记忆
│   ├── hooks/
│   │   ├── timesense.sh              # 每条消息注入当前时间
│   │   ├── memory_signal.sh          # 每条输入做 P/S/E 记忆分类
│   │   ├── thinking_protocol.sh      # 每条输入注入层级思考协议
│   │   └── session_end.sh            # 告别语触发 daily-review
│   ├── skills/
│   │   ├── daily-review/SKILL.md     # 对话结束汇总流程
│   │   ├── week-sync/SKILL.md        # 启动状态同步（轻量/深度两档）
│   │   └── weekly-review/SKILL.md    # 周日全量复盘 + 归档
│   └── agents/
│       ├── research-agent.md         # 学术文献检索 agent
│       └── general-search-agent.md   # 通用网页 + 对话回溯 agent
│
└── assistant/                        # 你的知识库与工作记忆
    ├── LTM.md                        # 长时程记忆（处境 + 时间轴 + 周录）
    ├── ITERATION_LOG.md              # 架构变更日志（版本化）
    ├── 00 Focus Zone/                # 周工作台
    │   ├── _本周.md                   # 当前周文件（任务 + 进展）
    │   ├── 00.focus_agent.md         # 区域规则
    │   └── _归档/                     # 已归档的周文件
    ├── 01 Projects/                  # 项目文件夹
    │   └── 00.projects_agent.md      # 区域规则
    ├── 02 Reading/                   # 阅读笔记
    │   └── 00.reading_agent.md       # 区域规则
    ├── 03 Writing/                   # 写作产出
    │   └── 00.writing_agent.md       # 区域规则
    ├── MEMORY/                       # 记忆候选池
    │   ├── 00.memory_agent.md        # 记忆区规则与模板
    │   ├── procedural_memory.md      # AI 行为模式（情境→行动）
    │   ├── semantic_memory.md        # 用户偏好与认知框架
    │   └── MEMORY_LOG.md             # 记忆代谢日志
    ├── SOUL/persona/                 # AI 人格身份
    │   └── persona_SOUL.md           # 人格定义与行为
    └── USER/                         # 用户身份档案
        ├── USER.md                   # 主档案（每次启动加载）
        ├── background.md             # 个人背景
        ├── personality.md            # 人格测评
        ├── cognition.md              # 认知档案
        └── beliefs.md               # 核心信念与价值观
```

## 工作原理

### 加载链

系统中每个文件声明它的**上游**（谁加载它）和**下游**（它管辖什么）。这构成一个有向图，Claude 在启动时沿着它走：

```
CLAUDE.md（Claude Code 自动加载）
  → 步骤 1：persona_SOUL.md（AI 身份层）
  → 步骤 2：USER.md（用户身份层）
  → 步骤 3：procedural_memory.md + semantic_memory.md（行为模式候选池）
  → 步骤 4：LTM.md §当前处境 + §时间轴（上下文）
  → 步骤 5：_本周.md（本周工作）
  → 步骤 6：week-sync skill（状态同步）
```

长对话压缩（compact）后，`settings.json` 中的 4 条 hook 自动重新注入步骤 1-3，确保身份和行为规则永不丢失。

### 记忆系统（Schema Prediction）

记忆系统分三层：

| 层 | 存什么 | 位置 | 毕业目标 |
|---|--------|------|----------|
| **情景层** | 事件、进展、决策 | `_本周.md` → `LTM.md` | 归档，不毕业 |
| **语义层** | 用户偏好、认知框架 | `semantic_memory.md` | `USER.md` |
| **程序层** | AI 行为规则（遇 X 做 Y） | `procedural_memory.md` | `persona_SOUL.md` |

每条语义/程序条目是一个 **schema**——对用户在特定情境下行为的预测。每条用户输入都会与已有 schema 比对：

- **命中 + 符合预期** → 静默使用，不写入（Low 惊奇度）
- **命中 + 偏离预期** → 三种动作：升星已有条目 / 新增例外条目 / 修正已有条目的情境边界或预期（High 惊奇度，★★★ 入池）
- **未命中** → 新建 ★ 条目（Medium 惊奇度）

条目通过反复观察积累星级（★→★★→...→★★★★★）。达到 ★★★★★ 时，经 weekly-review 确认后**毕业**——从候选池迁入永久身份层（USER.md 或 persona_SOUL.md），成为 AI 稳定世界模型的一部分。

连续 4 周以上未被引用的条目会衰减并最终删除。候选池是代谢层，不是仓库。

### 周循环

| 时机 | 发生什么 |
|------|----------|
| **会话启动** | week-sync 运行：周一至周四轻量状态同步，周五至周日深度回溯（含文件差集扫描） |
| **会话中** | 每条消息通过 hook 检测记忆信号；进展写入 `_本周.md` |
| **会话结束** | daily-review：扫描 P/S/E 信号、更新记忆、写进展日志 |
| **周日** | weekly-review：全景摘要 → 主线对齐检查 → 记忆代谢 → 毕业检查 → 归档 |

### 四个 Hook

| Hook | 触发时机 | 作用 |
|------|----------|------|
| `timesense.sh` | 每条消息 | 注入当前时间，让 AI 有时间感知 |
| `memory_signal.sh` | 每条消息 | 提示 AI 对输入做 P/S/E 信号分类 |
| `thinking_protocol.sh` | 每条消息 | 注入层级思考协议（理解→评估→梳理→质疑→执行） |
| `session_end.sh` | 告别语 | 触发对话结束复盘流程 |

## 初始化指南

### 前置条件
- 已安装 [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- 可用的 Bash shell（Windows 上 Git Bash 即可）

### 安装步骤

1. **把 `.claude/` 内容复制到你的 Claude Code 配置目录**（`~/.claude/`）：
   ```bash
   cp -r .claude/CLAUDE.md ~/.claude/
   cp -r .claude/hooks/ ~/.claude/hooks/
   cp -r .claude/skills/ ~/.claude/skills/
   cp -r .claude/agents/ ~/.claude/agents/
   ```

2. **把 `assistant/` 放到你想要的位置**（如 `~/Assistant/` 或 `D:/Assistant/`）：
   ```bash
   cp -r assistant/ ~/Assistant/
   ```

3. **替换路径**：在所有文件中搜索 `<ASSISTANT_ROOT>`，替换为你的实际路径：
   - `CLAUDE.md` — 启动序列中的所有文件引用
   - `settings.json` — 4 条 SessionStart(compact) cat hook
   - skill 文件 — 下游文件引用

4. **合并 `settings.json`**：如果你已有 `~/.claude/settings.json`，把 hooks 配置合并进去，不要覆盖。关键设置：
   - `autoMemoryEnabled: false` — 禁用 Claude Code 内置自动记忆（与本系统冲突）
   - `hooks.SessionStart` — 4 条 compact 后重注入 hook
   - `hooks.UserPromptSubmit` — timesense + memory_signal + thinking_protocol + session_end

5. **自定义身份文件**：
   - 编辑 `USER/USER.md` — 填入你的身份、认知模式、协作偏好
   - 编辑 `SOUL/persona/persona_SOUL.md` — 定义 AI 人格的名字、语气和风格
   - 编辑 `LTM.md §当前处境` — 描述你当前的处境和优先级

6. **自定义告别语触发词**：`settings.json` 中 `session_end.sh` 的 matcher 默认是 `"good night|bye|see you|that's all for today"`，改成你常用的告别语。

7. **启动新的 Claude Code 会话**。Claude 会读取 `CLAUDE.md`，沿加载链走，发现空模板文件，通过对话开始填充。

### 第一次会话

第一次会话时，Claude 会：
1. 读取 CLAUDE.md，执行启动序列
2. 发现大部分是空模板文件
3. 运行 week-sync（会报告空状态）
4. 通过对话开始了解你

随着使用，系统自行填充：
- 工作进展填入 `_本周.md`
- 记忆条目在候选池中积累
- `LTM.md` 构建你的跨周时间轴
- 周复盘执行代谢，稳定的模式毕业进入身份层

### 添加自定义 Agent

在 `.claude/agents/` 中新建 `.md` 文件，参照已有 agent 格式。然后在 `CLAUDE.md §B 启动序列` 的触发表中加一行。

### 添加自定义 Skill

在 `.claude/skills/` 中新建目录，包含 `SKILL.md` 文件。Claude Code 自动发现该目录下的 skill。

## 设计原则

- **加载链而非记忆**：文件声明自己的关系。AI 通过跟随链接导航，不靠记住整个结构。
- **单一权威源**：每条信息只有一个权威位置。其他位置只能放摘要 + 指针。
- **候选池代谢**：记忆条目不是永久的。必须通过反复观察证明稳定性，才能毕业到身份层。
- **三级风险分级**：操作按可逆性和影响范围分为静默（S，直接做）、通知（N，告知用户）、确认（C，等审批）。
- **Hook 驱动一致性**：关键行为（时间感知、记忆检测、推理质量）由 hook 强制执行，而不是指望 AI 自己记住。

## 自定义

这是一个模板，按需调整：

- **语言**：所有文件内容可以用任何语言。Hook 输出默认是中文，编辑 printf 字符串即可更改。
- **人格**：AI 人格在 `persona_SOUL.md` 中完全自定义。命名、赋予声音、定义与你的关系。
- **区域结构**：四个区域（专注区、项目区、阅读区、写作区）是建议。按需重命名、增删。
- **思考协议**：`thinking_protocol.sh` 中的层级推理是有主张的设计。修改层级以匹配你偏好的交互风格。
- **记忆参数**：衰减周期（4 周）、毕业阈值（★★★★★）、膨胀上限（每池约 30 条）均可调整。
- **Sub-agent**：按你的工作领域添加专用检索 agent。

## 许可证

MIT
