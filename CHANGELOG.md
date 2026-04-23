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

## v0.3.0 · 2026-04-24 · 中文化 + 节点级工作流

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
6. **同步完成后 · 全版本对照**：上述 5 条是本版本的显性变更点。若本地基线距此版本较远，建议有余力时跑一次 `git diff <本地基线-tag> v0.3.0 -- .claude/ assistant/00*/00.*_agent.md` 做全版本对照，避免漏掉零碎调整（措辞微修 / 指针更新 / 边角规则）

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
