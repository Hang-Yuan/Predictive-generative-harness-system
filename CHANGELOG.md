# CHANGELOG

> 模板版本迭代记录。每次 push 追加一条，从顶部插入（新→旧）。
>
> **使用者的 AI 读取指引**：
> - 从顶部最新条目扫起，按 §同步建议 判断本地需要合并的改动
> - 若本地系统基于较早版本定制过，同步完最近几条后建议做一次**全版本对照**（`git diff <本地基线> HEAD`）确认无遗漏
> - §不受影响 节明确列出本次不需要动的模块，可直接跳过
>
> **版本号规则**（语义化版本）：
> - `major` — 破坏性变更（协议结构改动、文件重命名、加载链改道）
> - `minor` — 新增功能（新 skill / agent / 协议节）
> - `patch` — 参数调整 / 措辞修正 / 文档补强

---

## v0.5.0 · 2026-05-07 · v5 默认遗忘记忆架构（破坏性）

### 背景

v0.4.x 的 P/S 双池会把一次性情景信号过快写入长期候选池，容易造成冗余、启动注入膨胀和判断污染。本版改为默认遗忘：实时信号先落入 episodic inbox，只有反复复现并通过 review 的候选才逐级升格。

### 新增组件

- `assistant/MEMORY/episodic_inbox.md` — 实时校准信号收件箱
- `assistant/MEMORY/episodic_memory.md` — 1-3 星情景级候选 schema
- `.claude/hooks/session_context_check.sh` — 节点收尾与项目加载提示 hook

### 架构变更

- `CLAUDE.md` 同步 v5：启动注入只读 persona / USER / `semantic_memory.md`，不再注入低星候选池。
- 记忆系统改为 `episodic_inbox -> episodic_memory -> semantic_memory -> identity` 单向上行；semantic 可因击穿或衰减降回 episodic。
- `memory_signal.sh` 改为 P/C 两轴判定：P 轴=命中 / 击穿 / 未覆盖；C 轴=正向确认 / 反对 / 纠正 / 中性。仅 `P=命中 且 C=中性` 不写，其余先入 inbox。
- `semantic_memory.md` 成为唯一启动注入候选池，默认最多 8 条；证据统一外移到 `_archive/semantic_archive.md`。
- `procedural_memory.md` 与 `_archive/procedural_archive.md` 从模板移除；程序型候选通过 `episodic_memory.md` / `semantic_memory.md` 的 `类型=程序` 字段表达。
- close-node / daily-review / weekly-review 对齐 v5：节点级聚合、日级 inbox 消耗、周级 semantic 升降与毕业候选。

### 参数调整

- episodic inbox 未升格条目默认保留 7 天。
- episodic memory 使用 1-3 星；semantic memory 使用 4-6 星。
- semantic 启动注入组默认最多 8 条。
- 毕业条件改为 6 星 + 跨周稳定 + 用户 C 级确认。

### 同步建议

**破坏性变更。** 对基于 v0.4.x 定制过的使用者：

1. 先备份本地 `assistant/MEMORY/`。
2. 新增 `episodic_inbox.md` 与 `episodic_memory.md`，用新版 `00.memory_agent.md` 替换旧规则。
3. 将旧 `procedural_memory.md` 和 `semantic_memory.md` 条目按类型迁入 `episodic_memory.md`；不要直接灌入新版 `semantic_memory.md`。
4. 删除或停用旧 `procedural_memory.md` / `procedural_archive.md`，保留 `semantic_archive.md` 作为新版证据外移文件。
5. 整套替换 `.claude/CLAUDE.md`、`.claude/hooks/memory_signal.sh`、`.claude/settings.json`，并新增 `session_context_check.sh`。
6. 同步 close-node / daily-review / weekly-review / write-progress；它们承担 v5 的流转边界。

### 不受影响

- USER.md / persona_SOUL.md 的基本模板结构
- 长期记忆.md 与项目区结构
- `.claude/agents/`
- create-project / new-file / manage-research-reference 的核心职责

---

## v0.4.0 · 2026-04-29 · v3.2 协议压缩 + 候选池证据外迁（破坏性）

### 背景

本版把主控规则从“完整说明书”改为“什么时候调用什么”的路由层：CLAUDE.md 只保留全局判断、写入路由和启动链，流程细节下沉到 hooks / skills / MEMORY 区域 agent。目标是降低常驻注入成本，同时保留可执行边界。

### 新增组件

- `.claude/skills/new-file/SKILL.md` — 新建 Markdown 文件时强制补加载链（上游 / 管辖文件 / 同级联动）
- `.claude/skills/manage-research-reference/SKILL.md` — 科研类项目 `_reference/文献记录.md` 管理；正文行内只保留 `(Author, Year)` 简标
- `assistant/MEMORY/_archive/procedural_archive.md`
- `assistant/MEMORY/_archive/semantic_archive.md`

### 架构变更

- `CLAUDE.md` 同步 v3.2：主控层瘦身，旧 §M.4–M.12 合并到 §M.1 / §M.2 / §M.3、§I 单一权威源、§R 行为路由表和各 skill 内部规则
- `memory_signal.sh` 改为按 §M 做 schema 比对：命中候选池后无论符合还是修正，方向都是升星；偏离不是 schema 失败，而是边界需要精修
- 候选池主池字段外迁：`procedural_memory.md` / `semantic_memory.md` 主池只保留运行字段，发现日期 / 证据 / related / 演化记录进入 `_archive/`
- `close-node` 增加 progress → S 候选提取；`weekly-review` 增加周级暂存复审输入
- `MEMORY_LOG.md` 增加 `§周复盘暂存`，承接未达即时入池标准但值得周级复审的 schema 信号

### 参数调整

- Bloat 阈值明文化为：MEMORY 单文件 ≤30 条，P/S 合计 ≤60 条
- `thinking_protocol.sh` 改为四步：分析 → 检索 → 推导 → 执行

### 路径与命名

- `MEMORY_LOG.md` 与 `ITERATION_LOG.md` 均位于 `assistant/` / `assistant/MEMORY/` 的真实位置，不再使用旧 `00 专注区` 路径
- B 端继续使用占位路径 `<ASSISTANT_ROOT>/`、人格占位 `persona`、中文化区域名 `00 专注区` / `01 项目区` / `02 阅读区` / `03 写作区`

### 同步建议

**破坏性变更。** 对基于 v0.3.x 定制过的使用者：

1. 先备份本地 `assistant/MEMORY/`。
2. 整套替换 `.claude/hooks/thinking_protocol.sh`、`.claude/hooks/memory_signal.sh` 与 `.claude/CLAUDE.md`；不要对旧 CLAUDE.md 做增量补丁。
3. 按本版模板重组候选池字段：主池只保留 schema 本体，证据与演化记录迁入 `_archive/`。
4. 同步 `close-node` / `weekly-review` / `write-progress` / `create-project` / `daily-review` 五个既有 skill，并新增 `new-file` 与 `manage-research-reference`。
5. 若本地已有真实 P/S 条目，不要直接覆盖；先把原证据迁入 `_archive/` 后再替换主池格式。

### 不受影响

- USER.md / persona_SOUL.md 的节结构
- 长期记忆.md 与项目区既有内容
- `.claude/agents/`
- `.claude/settings.json`

---

## v0.3.2 · 2026-04-25 · 毕业条目拆分：身份层净化 + MEMORY_LOG 完整归档

### 背景

发现毕业流程设计缺陷：原流程把候选池条目（含强度/来源/证据/related 等 log 元数据）整体搬到 USER.md / persona_SOUL.md，导致身份层被流水字段污染。身份层应是稳态规则，不是审计日志。

### 协议变更

**毕业是条目重写，不是搬运**。毕业流程拆两端：

1. **身份层只留净描述**：程序层写 标题 + 触发情境 + 行动模式；语义层写 标题 + 情境 + 预期。剥掉强度 / 来源 / related / 证据 / 备注等 log 字段。
2. **MEMORY_LOG §毕业归档 节新增**：完整毕业条目（含原元数据 + 毕业日期 + 毕业去向 + 剥壳后净版副本）归档于此，单事件级审计落点。
3. **§操作日志仅留一行指针**：`YYYY-MM-DD | 毕业：[条目名] → [目的地]（详见 §毕业归档）`。

### 文件变更

- `assistant/MEMORY/00.memory_agent.md` §毕业 — 重写为四步流程（剥壳写入 / 原条目标毕业 / 完整归档 / 指针）；version 3.0 → 3.1
- `.claude/skills/weekly-review/SKILL.md` §步骤 6 — 明确剥壳字段清单 + 完整归档 + 指针（6 步改 7 步）
- `assistant/MEMORY/MEMORY_LOG.md`：
  - §条目模板 新增"毕业归档模板"
  - 周复盘模板毕业字段加"完整归档见 §毕业归档"指针
  - 文件末新增 §毕业归档 节（占位）
  - version 3.0 → 3.1

### 同步建议

**对本地基于 v0.3.x 的使用者**：

1. 照搬三处改动到本地对应文件（路径一致）。若本地未发生过毕业事件，不需要追溯迁移任何历史条目。
2. 若本地已有条目毕业到 USER.md / persona_SOUL.md 且带 log 字段：手动清理身份层的日志字段，把原始条目快照补写到 MEMORY_LOG §毕业归档（可选，历史审计用）。
3. 本变更与既有候选池条目格式完全兼容——候选池条目格式本身未变，只改写入身份层时的剥壳规则。

### 不受影响

- 候选池条目格式（procedural_memory / semantic_memory 内条目结构）
- USER.md / persona_SOUL.md 节结构
- 毕业触发条件（★★★★★ + 跨周稳定 + weekly-review 确认）
- 其他 skill / hook / agent

---

## v0.3.1 · 2026-04-24 · 中文化 + 节点级工作流

### 新增组件

- `.claude/skills/close-node/` — 节点闭合 7 步流程（主文档 / _overview / _progress / 指针链 / 任务勾选 / 悬置）。AI 自判触发 → N 级提议，适用于"讨论收束 / 子问题解决 / 任务完成"场景
- `.claude/skills/create-project/` — 新建项目流程（建 `_overview.md` + portfolio 登记 + 子目录规划 + 跨项目互通登记）
- `.claude/skills/write-progress/` — 推进记录写入规范。包含：推论链管家文件（按项目类型命名）/ 推进展开子文件 / 推论链导览（带桥句）/ 每节强制问题承接-开出字段
- `.claude/agents/phd-agent.md`、`.claude/agents/business-agent.md` — 领域 sub-agent 占位（使用者按自己领域搭建，参考 research-agent.md 架构）
- `assistant/01 项目区/00.项目区_agent.md` — 项目区域规则（Portfolio 全项目索引 / 跨项目授权索引 / 项目生命周期 / 归档动作 6 步 / 项目内部结构规范）

### 架构变更（CLAUDE.md）

- **§B 启动序列 硬触发声明**：上下文中无身份层（persona_SOUL / USER / P / S）痕迹时，必须先完整执行 7 步启动序列再响应
- **§B 启动序列 步骤 7 新增**：读 MEMORY_LOG + ITERATION_LOG 尾部 40 行（系统层近期状态：记忆代谢节奏 + 协议变更）
- **§B 新增 §项目工作加载 节**：已有项目 4 步加载流（判断+确认 → 读 _overview → 读推进管家 → 反馈+用户选择）；新建项目调 create-project skill
- **§B 触发表新增 5 行**：create-project / write-progress / close-node / phd-agent / business-agent
- **§R 时间感知 新增 §逻辑日期口径**：凌晨工作归属前一日的判定规则 + 写入字段范围
- **§M.5 E 类写入补充**：当前在项目区时 → 推进过程写 `_progress/`（由 write-progress 管辖）；结论写主文档对应节
- **§M.11 B 表新增**：`项目内节点级工作收束 → 见 §M.12`
- **§M.12 新节**：任务状态实时维护（`_本周.md §本周任务` 清单触发 → 调 close-node）

### 参数调整

- **逻辑日期阈值 04:00 → 06:00**（daily-review §0 / weekly-review §0 / CLAUDE.md §R）
  - 影响：凌晨 04:00–06:00 的工作现在归属**前一日**（原归属新一日）
  - 原因：实际生活作息下，06:00 前的工作多是前一日延续

### 流程补强

- **daily-review 新增 §3.5 节点闭合兜底扫描**：长工作日捡漏未经 close-node 处理的已闭合节点
- **daily-review §4 归档日额外检查**：周日强制确认 `### 本周产出` 节存在于进展记录末尾
- **weekly-review §8b 详细周录格式约束**：固定为"按项目展开 + 关键认识"，整节 7-10 行，不写下周重点

### 路径与命名

- **目录全面中文化**（面向中文使用者更直观）：
  - `00 Focus Zone/` → `00 专注区/`
  - `01 Projects/` → `01 项目区/`
  - `02 Reading/` → `02 阅读区/`
  - `03 Writing/` → `03 写作区/`
  - `LTM.md` → `长期记忆.md`
- CLAUDE.md §X 常用路径 + 各 skill 下游清单 + 各 agent 加载链 已同步更新

### 同步建议

**对本地基于 v0.2.x 定制过的使用者**：

1. **目录重命名冲突**：若本地已改过区域目录结构/名称，对比两侧后手动取舍；路径硬编码在 CLAUDE.md §X 常用路径、各 skill 下游清单、各 agent 加载链中——用 grep 扫一遍旧目录名确认无残留
2. **CLAUDE.md 合并**：§M.12 整节、§B §项目工作加载 / 步骤 7、§R 逻辑日期口径 —— 这几节是增量叠加，若本地 CLAUDE.md 已自定义可直接 append
3. **逻辑日期阈值**：本地 daily-review / weekly-review 若已调过时间阈值，留意 04:00 / 06:00 的冲突；以当前生活作息为准选择
4. **新 skill 引入**：close-node / create-project / write-progress 三个不依赖既有状态，可直接复制；phd-agent / business-agent 是占位文件，按各自领域改写
5. **项目区 agent**：portfolio 表 + 跨项目授权索引是空模板；若本地已有同名文件需手动 merge，勿直接覆盖
6. **同步完成后 · 全版本对照**：上述 5 条是本版本的显性变更点。若本地基线距此版本较远，建议有余力时跑一次 `git diff <本地基线-tag> v0.3.1 -- .claude/ assistant/00*/00.*_agent.md` 做全版本对照，避免漏掉零碎调整（措辞微修 / 指针更新 / 边角规则）

### 不受影响

- **MEMORY/ 候选池格式**（P/S 三层架构 + 星级机制 + schema 预测）未变
- **USER.md / persona_SOUL.md 骨架**未动
- **hook 脚本接口 / settings.json 结构**未变（仅内部措辞微调，对外 matcher / context 字段结构一致）
- **week-sync / weekly-review 主流程步骤编号**未变（仅补强细节）
- **长期记忆.md 结构**（§当前处境 / §时间轴 / §详细周录）未变（仅文件名本地化）

---

## v0.2.x 及更早

历史版本未做结构化记录。使用者如需回溯，可参考：

- `git log --oneline` 查看 commit 历史
- 主要里程碑：
  - `v0.2.x` — 全面汉化 + 写入前置约束机制 + persona 私记模块剥离
  - `v0.1.x` — 初版发布（Predictive Generative Harness System 命名）
