---
title: weekly-review/SKILL.md
type: skill
name: weekly-review
description: 周复盘流程。v5：周级 semantic schema 提取、episodic 衰减、语义层升降、毕业候选与周归档。触发条件：周日 daily-review 自动调用、week-sync 周日提示、或用户手动触发复盘。
updated: 2026-05-07
---

# weekly-review

## 加载链

**上游**：daily-review 步骤 6.5（周日自动）/ week-sync 周日检测 / 用户触发词

**下游**：
- `<ASSISTANT_ROOT>\00 专注区\_本周.md` — 写入本周产出节 + 周归档。
- `<ASSISTANT_ROOT>\MEMORY\episodic_inbox.md` — 读取未消耗的实时校准信号。
- `<ASSISTANT_ROOT>\MEMORY\episodic_memory.md` — 读取 1-3 星情景候选，执行提取、回写、衰减。
- `<ASSISTANT_ROOT>\MEMORY\semantic_memory.md` — 4-6 星启动注入 schema 主文件。
- `<ASSISTANT_ROOT>\MEMORY\_archive\semantic_archive.md` — 语义层证据、命中、演化记录。
- `<ASSISTANT_ROOT>\MEMORY\MEMORY_LOG.md` — 记忆代谢周复盘与毕业归档。
- `<ASSISTANT_ROOT>\长期记忆.md` — 当前处境、时间轴、详细周录。
- `<ASSISTANT_ROOT>\USER\USER.md` — USER 毕业写入，需 C 级确认。
- `<ASSISTANT_ROOT>\SOUL\persona\persona_SOUL.md` — SOUL 毕业写入，需 C 级确认。
- `~/.claude/skills\` — 流程化毕业写入，需 C 级确认。

**同级联动**：
- `daily-review/SKILL.md` — 周日触发 weekly-review，并提供日级补捞结果。
- `close-node/SKILL.md` — 节点级提取结果进入周级代谢。
- `write-progress/SKILL.md` — In_Progress / `_progress` 只作为项目推论链输入，不作为记忆写入落点。

---

## v5 目标

周复盘是 v5 记忆系统的周级权威入口，负责四件事：

1. 从 episodic_memory / 项目推进证据中检查可迁移 semantic schema。
2. 对 semantic_memory 执行升星、降星、合并、退出启动注入。
3. 对 episodic_inbox / episodic_memory 执行衰减、归档、合并复审。
4. 执行毕业候选审查：6 星候选 + 非机械抽象 + 用户 C 级 verdict。

---

## 写入前置约束（强制）

凡涉及写入下列文件，写入前必须先读取目标文件当前格式与相关模板：

- `<ASSISTANT_ROOT>\MEMORY\00.记忆区_agent.md`
- `<ASSISTANT_ROOT>\MEMORY\episodic_inbox.md`
- `<ASSISTANT_ROOT>\MEMORY\episodic_memory.md`
- `<ASSISTANT_ROOT>\MEMORY\semantic_memory.md`
- `<ASSISTANT_ROOT>\MEMORY\_archive\semantic_archive.md`
- `<ASSISTANT_ROOT>\MEMORY\MEMORY_LOG.md`
- `<ASSISTANT_ROOT>\ITERATION_LOG.md`
- `<ASSISTANT_ROOT>\00 专注区\_本周.md`
- `<ASSISTANT_ROOT>\长期记忆.md`
- `<ASSISTANT_ROOT>\USER\USER.md`（毕业写入，C 级确认）
- `<ASSISTANT_ROOT>\SOUL\persona\persona_SOUL.md`（毕业写入，C 级确认）
- `~/.claude/skills\`（skill 毕业写入，C 级确认）

写入事务必须闭合：

- semantic new/up/mod/merge/graduate：`semantic_memory.md` 主文件 + `_archive/semantic_archive.md` 证据 + MEMORY_LOG；若来源是 episodic，回写 episodic 提取记录、最后激活、提取次数。
- inbox 消耗：已升格 / 已吸收 / 已修正 / 无保留价值的 `episodic_inbox.md` 行物理删除；仍需观察的保留为 `活动`；行级写入 / 删除为 N 级，执行后汇总。
- episodic 状态变化 / 归档：主文件状态或移出，不做物理删除。
- 架构 / skill / 协议变更写 `ITERATION_LOG`，不写 `MEMORY_LOG §操作日志`。

---

## 触发机制

| 方式 | 何时 | 谁触发 |
|---|---|---|
| 自动触发 | 周日 daily-review 步骤 6.5 | daily-review 调用 |
| 启动提示 | 周日 week-sync 检测到未完成 | week-sync 提示 |
| 手动触发 | 任意时刻 | 用户说复盘 / weekly review / 本周总结等触发词 |

每周日必须完成一次。若周日彻夜跨过 06:00，按逻辑日期规则判定周归属。

---

## 准备（执行前加载）

1. 读取 `_本周.md` 全文。
2. 读取 `长期记忆.md §当前处境` + `§时间轴`。
3. 读取 `MEMORY\00.记忆区_agent.md`，确认 v5 记忆规则。
4. 读取 `MEMORY\episodic_inbox.md` 活动条目。
5. 读取 `MEMORY\episodic_memory.md` 全文。
6. 读取 `MEMORY\semantic_memory.md` + `_archive\semantic_archive.md` 全文。
7. 读取 `MEMORY\MEMORY_LOG.md` 尾部与 §周复盘模板。
8. 从 `_本周.md` 识别本周活跃项目，读取各项目 `_overview.md`。
9. 对本周 touched 项目，按需读取 `_progress/` 管家文件和涉及节点，不全项目盲扫。

---

## 复盘流程（严格顺序）

### 步骤 0 · 逻辑日期判定

读取当前物理时间。

- 物理 hour < 06:00 → 逻辑日期 = 物理日期 - 1。
- 物理 hour ≥ 06:00 → 逻辑日期 = 物理日期。

后续周次归属、`_本周.md` 归档、`MEMORY_LOG` 日期、`长期记忆` 周录均使用逻辑日期。

---

### 步骤 1 · 全景摘要

根据 `_本周.md` 进展记录生成本周全景，覆盖：

- 任务完成情况。
- 核心推进。
- 关键产出。
- 关键决策。
- 跨项目连接。
- 意外收获。
- 遗留未完成项。

向用户呈现后继续步骤 2。

---

### 步骤 2 · 给用户空间

全景摘要后，用自然语言给用户补充空间：

> 这是本周的全景。有没有什么特别重要的事情、转变、或者你自己的感受，你想先说说的？

等待用户补充，将补充纳入后续步骤。

---

### 步骤 3 · 主线对齐检查

对照 `长期记忆.md §当前处境`，检查：

1. 本周是否推进了当前主要矛盾。
2. 有没有偏移到主线以外，值不值。
3. `长期记忆.md §当前处境` 是否需要更新。

有实质变化 → 覆盖更新 `长期记忆.md §当前处境`（S 级）。无变化 → 跳过。

---

### 步骤 3.5 · 情景 / 项目证据到语义 schema 检查

这是 v5 中从情景证据进入 semantic_memory 的唯一周级通道。

#### 输入

- `episodic_inbox.md` 中未消耗但明显高价值的条目。
- `episodic_memory.md` 中活动条目。
- 本周 touched 项目的 In_Progress / `_progress` 节点：
  - L2 `推进` 中的 `**开出**`
  - L2 `新问题`
  - L3 `问题承接`
  - L3 `→ 开出的新问题`
  - L3 `→ 本节收束`
- daily-review 标记的日级补捞结果。
- close-node 节点级分流结果。

#### 前置过滤

1. 先匹配身份层与现有 semantic schema：
   - 命中 USER/SOUL 且只是符合旧认知 → 不写。
   - 命中 USER/SOUL 但出现抵触 / 新扰动 → 写 episodic 或提交裁决，不直接改身份层。
   - 击穿现有 semantic schema → 进入步骤 4b 做降星 / 修订。
2. 再判断权威源：
   - 项目结论 → 项目主文档 / progress，不进记忆池。
   - 具体事件 / 异常 / 现场观察 → episodic。
   - 可运行的跨情景 schema → semantic 候选。

#### semantic 提取判准

从 episodic / progress 提取 semantic 必须同时满足：

1. 能写成非机械的「预测情境→行动预期」。
2. 跨日、跨节点或跨情境复现；重大安全 / 越权 / 系统事故可单条保留，但必须写明复审条件。
3. 有 P轴 / C轴证据，且不是单纯事实正确。
4. 不与 USER/SOUL、项目主结论、长期记忆 当前处境冲突。

分类：

- 稳定运行预测 → `semantic_memory.md`。
- 流程化行动规则 → 先作为 semantic 毕业候选，等待 C verdict 后写入 skill。
- 身份层稳定模式 → 先作为 semantic 毕业候选，等待 C verdict 后写 USER / SOUL。

#### 星级

| 状态 | 含义 | 动作 |
|---|---|---|
| 1-3 星 | 情景层候选 | 留在 `episodic_memory.md` |
| 4 星 | 可启动注入的语义 schema | 写入 `semantic_memory.md` |
| 5 星 | 稳定语义 schema | 保持启动注入或备用 |
| 6 星候选 | 毕业审查候选 | 进入步骤 6，不自动毕业 |

输出候选变更清单，进入步骤 4 / 5 统一执行。

---

### 步骤 4 · 记忆池审查

#### 4a · episodic 审查与衰减

逐条审查 `episodic_memory.md` 活动 / 复审条目：

| 条件 | 动作 |
|---|---|
| 本周被引用 / 提取 / 再次证明有用 | 回写最后激活；若提取为 semantic，提取次数 +1 |
| 4 周无激活且提取次数 0 | 状态改复审 |
| 6 周仍无激活且提取次数 0 | 从主文件移出，周归档索引保留 |
| 提取次数 1 且 8 周无再激活 | 复审 |
| 提取次数 ≥2 | 不按时间自动归档 |
| 提取次数 ≥5 | 复审是否应合并进 semantic 或项目规则 |

episodic_memory / semantic_memory 的归档不是删除；物理删除整份记忆文件仍属 C 级。L0 inbox 的行级写入 / 删除是 N 级默认遗忘代谢动作。

#### 4b · semantic_memory 审查

对 `semantic_memory.md` 全部条目逐一审查：

- 本周命中 / 复用 / 被证据支持 → `_archive/semantic_archive.md` 追加证据；必要时升星。
- 本周出现反证 / 失效 / 与身份层冲突 → 提出修正、合并、降级或退出启动注入；涉及删除或身份层影响时等待裁决。
- 相似条目重复 → 合并 semantic 主文件 schema，archive 保留证据来源。
- 启动注入超过 8 条 → 按优先级将最低项退回 `episodic_memory.md` 或备用组。
- 达 6 星候选 → 标记毕业审查候选，不自动写 USER/SOUL/skill。

semantic 不执行自动毕业。

---

### 步骤 5 · 强度调整与写入事务

根据步骤 3.5 + 步骤 4 的审查结果执行：

1. semantic 新增、升级、合并、修正：
   - `semantic_memory.md` 写极简 schema 本体。
   - `_archive/semantic_archive.md` 追加证据详记。
   - `MEMORY_LOG §操作日志` 追加一行代谢流水。
   - 若来源是 episodic，回写提取记录、最后激活、提取次数。
2. inbox / episodic 状态变化：
   - inbox 已消耗行物理删除；仍需观察的行保持 `活动`。L0 行级删除为 N 级，不问 C。
   - 主文件修改状态 / 提取次数 / 最后激活。
3. 项目结论不写 semantic，回项目主文档或 progress。

---

### 步骤 6 · 毕业检查

扫描 `semantic_memory.md` 中所有 6 星候选。6 星只是毕业审查候选，不能自动毕业。

毕业必须同时满足：

1. 6 星候选。
2. weekly-review 当场完成非机械抽象：能剥离证据、日期、项目细节，只留下稳定身份层描述。
3. 用户 C 级 verdict 明确通过。

毕业路径：

| 层 | 目的地 | 写入内容 |
|---|---|---|
| USER | `<ASSISTANT_ROOT>\USER\USER.md` 对应节 | 标题 + 情境 + 预期 / 稳定认知描述 |
| SOUL | `<ASSISTANT_ROOT>\SOUL\persona\persona_SOUL.md §行为模式` | 标题 + 触发情境 + 行动模式 + 预期后效 |
| skill | `~/.claude/skills\` 对应 skill | 触发条件 + 执行动作 + 边界 |

毕业是条目重写，不是搬运。身份层 / skill 不带星级、来源、证据、related、日期等日志字段。完整审计留在 semantic_archive + `MEMORY_LOG §毕业归档`。

---

### 步骤 7 · 写入 MEMORY_LOG 周复盘条目

追加到 `MEMORY_LOG.md §周复盘` 尾部。本条只记记忆系统代谢，不记工作进展。

模板：

```markdown
### YYYY-WNN 周复盘（YYYY-MM-DD）

**本周记忆操作**：
- inbox 消耗：[条目 ID/名称]（如无则「无」）
- 情景层新增 / 合并：[条目 ID/名称]（如无则「无」）
- 情景层状态变化：[活动 / 复审 / 已归档 / 合并复审]（如无则「无」）
- 语义层新增 / 合并：[条目名称]（如无则「无」）
- 情景 / 项目证据到语义提取：[条目名称]（如无则「无」）
- 修正 / 合并：[条目名称 原→新]（如无则「无」）
- 删除：[条目名称及原因]（如无则「无」）
- 毕业：[条目名称及目的地]（如无则「无」）

**强度变化**：
- 情景层升降：[条目名称 1→2 / 2→3 / 3→2]（如无则「无」）
- 语义层升降：[条目名称 4→5 / 5→6候选 / 4→3退回]（如无则「无」）

**衰减处理**：[inbox / episodic / semantic 处理了哪些条目，或「无」]

**复盘发现**：[本周记忆系统运行中发现的问题、模式、改进点，或「无」]

**下周迭代行动**：[记忆系统层面下周要做的调整，或「无」]

**参数调整**：[衰减周期/两轴阈值/星级阶梯等参数变动，或「无」]
```

---

### 步骤 7.5 · 写入 ITERATION_LOG（条件触发）

本周发生 skill / 协议 / 文件结构 / 记忆参数变更时，按 `ITERATION_LOG.md` 模板追加版本化条目。

不满足条件则跳过。架构变更不写 `MEMORY_LOG`。

---

### 步骤 8 · 周归档

复盘完成后执行周归档：

1. 在 `_本周.md §进展记录` 末尾追加 `### 本周产出`。
2. 将 `_本周.md` 归档为 `_归档/YYYY-Wnn.md`。
3. 更新 `长期记忆.md §时间轴` 顶部索引。
4. 在 `长期记忆.md §详细周录` 尾部追加本周详细周录。
5. 创建新周 `_本周.md`，保留标准加载链与任务清单空位。
6. 向用户自然报告归档完成。

---

## 不做

- 不启动情景层注入。
- 不把 In_Progress 当记忆写入落点。
- 不使用旧程序 / 语义双池。
- 不执行自动毕业。
- 不把 `MEMORY_LOG` 当作新信号入口；旧暂存记录仅作为兼容读取入口，不再新增。
- 不动 hook / settings。
