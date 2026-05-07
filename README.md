# Predictive Generative Harness System (PGH System)

一个为 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 设计的持久化记忆与工作流系统。赋予 Claude 跨会话的长期记忆、结构化项目管理和自我改进的行为模式。

> 📜 **最近更新见 [CHANGELOG.md](./CHANGELOG.md)** — 每次版本迭代的新增 / 变更 / 参数调整 / 本地同步建议。基于既有版本定制过的使用者请先扫这份。

## 这是什么

Claude Code 默认是无状态的——每个新会话从零开始。这套 harness 通过构建结构化的外部记忆系统解决这个问题：Claude 在启动时读取、在会话中和结束时写入。

**核心能力：**
- **默认遗忘的三层记忆**（episodic inbox → episodic memory → semantic memory → identity），带自动代谢（捕捉 → 复现 → 升格 → 毕业）
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
│   │   ├── memory_signal.sh          # 每条输入做两轴记忆信号判定
│   │   ├── thinking_protocol.sh      # 每条输入注入层级思考协议
│   │   ├── session_context_check.sh  # 节点收尾 / 项目加载提示
│   │   └── session_end.sh            # 告别语触发 daily-review
│   ├── skills/
│   │   ├── daily-review/SKILL.md     # 对话结束汇总流程
│   │   ├── week-sync/SKILL.md        # 启动状态同步（轻量/深度两档）
│   │   ├── weekly-review/SKILL.md    # 周日全量复盘 + 归档
│   │   ├── close-node/SKILL.md       # 节点级闭合
│   │   ├── create-project/SKILL.md   # 新建项目
│   │   ├── write-progress/SKILL.md   # 项目推进记录
│   │   ├── new-file/SKILL.md         # 新文件加载链兜底
│   │   └── manage-research-reference/SKILL.md # 文献记录管理
│   └── agents/
│       ├── research-agent.md         # 学术文献检索 agent
│       └── general-search-agent.md   # 通用网页 + 对话回溯 agent
│
└── assistant/                        # 你的知识库与工作记忆
    ├── 长期记忆.md                        # 长时程记忆（处境 + 时间轴 + 周录）
    ├── ITERATION_LOG.md              # 架构变更日志（版本化）
    ├── 00 专注区/                # 周工作台
    │   ├── _本周.md                   # 当前周文件（任务 + 进展）
    │   ├── 00.专注区_agent.md         # 区域规则
    │   └── _归档/                     # 已归档的周文件
    ├── 01 项目区/                  # 项目文件夹
    │   └── 00.项目区_agent.md      # 区域规则
    ├── 02 阅读区/                   # 阅读笔记
    │   └── 00.阅读区_agent.md       # 区域规则
    ├── 03 写作区/                   # 写作产出
    │   └── 00.写作区_agent.md       # 区域规则
    ├── MEMORY/                       # 记忆候选池
    │   ├── 00.memory_agent.md        # 记忆区规则与模板
    │   ├── episodic_inbox.md         # 实时校准信号收件箱
    │   ├── episodic_memory.md        # 1-3 星情景级候选 schema
    │   ├── semantic_memory.md        # 4-6 星启动注入 schema
    │   ├── MEMORY_LOG.md             # 记忆代谢日志
    │   └── _archive/                 # semantic 证据与演化记录
    │       └── semantic_archive.md
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
  → 步骤 3：semantic_memory.md（启动注入 schema，最多 8 条）
  → 步骤 4：长期记忆.md §当前处境 + §时间轴（上下文）
  → 步骤 5：_本周.md（本周工作）
  → 步骤 6：week-sync skill（状态同步）
```

长对话压缩（compact）后，`settings.json` 自动重新注入 persona、USER 和 semantic memory，确保身份层与高价值 schema 不丢失。episodic 层不启动注入，只在 review 流程中读取。

### 记忆系统（Schema Prediction）

记忆系统分三层加一个身份层出口：

| 层 | 存什么 | 位置 | 毕业目标 |
|---|--------|------|----------|
| **episodic inbox** | 每条输入后的轻量校准信号 | `episodic_inbox.md` | 聚合后进入 episodic memory |
| **episodic memory** | 1-3 星候选 schema | `episodic_memory.md` | 稳定后升 semantic |
| **semantic memory** | 4-6 星启动注入 schema | `semantic_memory.md` | `USER.md` / `persona_SOUL.md` / skill |
| **identity** | 长期稳定特质、行为模式、流程 | `USER.md` / `persona_SOUL.md` / `skills/` | 常驻 |

每条记忆条目是一个 **schema**，即对未来同类情境的预测或行动约束。每条用户输入都会触发两轴判断：

- **P 轴（预测关系）**：命中 / 击穿 / 未覆盖
- **C 轴（校准信号）**：正向确认 / 反对 / 纠正 / 中性

只有 `P=命中 且 C=中性` 不写；其他组合先进入 `episodic_inbox.md`。close-node / daily-review 把复现信号聚合成 `episodic_memory.md` 候选；weekly-review 再把稳定 3 星候选升入 `semantic_memory.md`。semantic memory 控制启动注入上限（默认 8 条），证据写入 `MEMORY/_archive/semantic_archive.md`。

达到 6 星且跨周稳定后，经用户确认才能**毕业**到 USER / persona_SOUL / skill。默认动作是遗忘；候选池是代谢层，不是仓库。

### 周循环

| 时机 | 发生什么 |
|------|----------|
| **会话启动** | week-sync 运行：周一至周四轻量状态同步，周五至周日深度回溯（含文件差集扫描） |
| **会话中** | 每条消息通过 hook 检测两轴记忆信号；进展写入 `_本周.md` |
| **节点收尾** | close-node：把当前节点内的复现信号聚合为 episodic memory 候选 |
| **会话结束** | daily-review：消耗 inbox、更新 episodic memory、写进展日志 |
| **周日** | weekly-review：episodic → semantic、semantic 衰减/毕业候选、周归档 |

### 五个 Hook

| Hook | 触发时机 | 作用 |
|------|----------|------|
| `timesense.sh` | 每条消息 | 注入当前时间，让 AI 有时间感知 |
| `memory_signal.sh` | 每条消息 | 提示 AI 按 P/C 两轴判断是否写入 episodic inbox |
| `thinking_protocol.sh` | 每条消息 | 注入四步思考协议（分析→检索→推导→执行） |
| `session_context_check.sh` | 每条消息 | 提示节点收尾和项目加载，不自动执行 |
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
   - `settings.json` — compact 重注入 hook
   - skill 文件 — 下游文件引用

4. **合并 `settings.json`**：如果你已有 `~/.claude/settings.json`，把 hooks 配置合并进去，不要覆盖。关键设置：
   - `autoMemoryEnabled: false` — 禁用 Claude Code 内置自动记忆（与本系统冲突）
   - `hooks.SessionStart` — compact 后重注入 persona / USER / semantic memory
   - `hooks.UserPromptSubmit` — timesense + memory_signal + thinking_protocol + session_context_check + session_end

5. **自定义身份文件**：
   - 编辑 `USER/USER.md` — 填入你的身份、认知模式、协作偏好
   - 编辑 `SOUL/persona/persona_SOUL.md` — 定义 AI 人格的名字、语气和风格
   - 编辑 `长期记忆.md §当前处境` — 描述你当前的处境和优先级

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
- `长期记忆.md` 构建你的跨周时间轴
- 周复盘执行代谢，稳定的模式毕业进入身份层

### 添加自定义 Agent

在 `.claude/agents/` 中新建 `.md` 文件，参照已有 agent 格式。然后在 `CLAUDE.md §B 启动序列` 的触发表中加一行。

### 添加自定义 Skill

在 `.claude/skills/` 中新建目录，包含 `SKILL.md` 文件。Claude Code 自动发现该目录下的 skill。

## 设计原则

- **加载链而非记忆**：文件声明自己的关系。AI 通过跟随链接导航，不靠记住整个结构。
- **单一权威源**：每条信息只有一个权威位置。其他位置只能放摘要 + 指针。
- **默认遗忘**：记忆条目不是永久的。信号先进入 episodic 层，只有反复复现并通过 review 才能进入 semantic / identity。
- **三级风险分级**：操作按可逆性和影响范围分为静默（S，直接做）、通知（N，告知用户）、确认（C，等审批）。
- **Hook 驱动一致性**：关键行为（时间感知、记忆检测、推理质量）由 hook 强制执行，而不是指望 AI 自己记住。

## 自定义

这是一个模板，按需调整：

- **语言**：所有文件内容可以用任何语言。Hook 输出默认是中文，编辑 printf 字符串即可更改。
- **人格**：AI 人格在 `persona_SOUL.md` 中完全自定义。命名、赋予声音、定义与你的关系。
- **区域结构**：四个区域（专注区、项目区、阅读区、写作区）是建议。按需重命名、增删。
- **思考协议**：`thinking_protocol.sh` 中的层级推理是有主张的设计。修改层级以匹配你偏好的交互风格。
- **记忆参数**：inbox 保留期、semantic 启动注入上限、衰减周期、毕业阈值均可调整。
- **Sub-agent**：按你的工作领域添加专用检索 agent。

## 许可证

MIT
