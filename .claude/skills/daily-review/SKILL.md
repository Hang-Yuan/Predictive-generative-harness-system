---
title: daily-review/SKILL.md
type: skill
name: daily-review
description: 对话结束汇总流程。v5：日级回扫、身份层前置过滤、episodic_inbox 代谢、项目结论/阶段决策分流；告别语触发后先完整执行汇总流程，再回应道别。
updated: 2026-05-07
---

# daily-review

## 加载链

**上游触发**：`~/.claude/hooks/session_end.sh` 检测告别语后注入触发信号；也可由用户明确要求本轮总结触发。

**下游文件**：
- `<ASSISTANT_ROOT>\MEMORY\episodic_inbox.md` — 日级读取和消耗实时校准信号。
- `<ASSISTANT_ROOT>\MEMORY\episodic_memory.md` — 日级聚合后的情景级候选。
- `<ASSISTANT_ROOT>\MEMORY\semantic_memory.md` — 只读启动注入 schema；daily-review 不升格。
- `<ASSISTANT_ROOT>\00 专注区\_本周.md` — 写今日进展。
- `<ASSISTANT_ROOT>\长期记忆.md` — 当前处境变化时更新。
- `<ASSISTANT_ROOT>\MEMORY\MEMORY_LOG.md` — 记录 inbox 升格、情景层衰减、语义层待复审标记。
- `<ASSISTANT_ROOT>\ITERATION_LOG.md` — 架构 / skill / 协议变更。

**同级联动**：
- `weekly-review/SKILL.md` — daily 不毕业，周级复盘才执行代谢与毕业。
- `close-node/SKILL.md` — daily 兜底检查是否有未闭合节点。

---

## 输出规则

所有用户可见输出都用自然对话段落，不输出步骤编号、流程标签或系统报告体。步骤编号只作为内部执行顺序。

---

## 写入前置约束（强制）

凡步骤涉及写入下列文件，必须先读取目标文件当前格式：

- `<ASSISTANT_ROOT>\MEMORY\00.记忆区_agent.md`
- `<ASSISTANT_ROOT>\MEMORY\episodic_inbox.md`
- `<ASSISTANT_ROOT>\MEMORY\episodic_memory.md`
- `<ASSISTANT_ROOT>\MEMORY\semantic_memory.md`
- `<ASSISTANT_ROOT>\MEMORY\_archive\semantic_archive.md`
- `<ASSISTANT_ROOT>\MEMORY\MEMORY_LOG.md`
- `<ASSISTANT_ROOT>\ITERATION_LOG.md`
- `<ASSISTANT_ROOT>\00 专注区\_本周.md`
- `<ASSISTANT_ROOT>\长期记忆.md`
- 当前项目主文档 / `_overview.md` / `_progress/`

写入事务要求：

- inbox 新增：只追加 `episodic_inbox.md` 文件末尾。
- inbox 升格：合并进 `episodic_memory.md`，并回写 inbox 状态。
- daily-review 不写 `semantic_memory.md`；只标记需要 weekly-review 复审。
- 项目结论 / 阶段决策：写项目权威源，不写入记忆池。
- 架构 / skill / 协议变更：写 ITERATION_LOG，不写 MEMORY_LOG。

---

## 汇总流程（严格顺序）

### 步骤 0 · 逻辑日期判定

读取当前物理时间。

- 物理 hour < 06:00 → 逻辑日期 = 物理日期 - 1。
- 物理 hour ≥ 06:00 → 逻辑日期 = 物理日期。

后续 `_本周.md`、`MEMORY_LOG`、`ITERATION_LOG`、任务完成日期均使用逻辑日期。

---

### 步骤 1 · 本轮记忆回扫

本步骤执行日级 `episodic_inbox -> episodic_memory` 代谢，替代旧版双池信号回扫。

#### 1a · 身份层前置过滤

对本轮观察先匹配 USER / SOUL：

| 匹配结果 | 动作 |
|---|---|
| 命中身份层 + 只是符合旧认知 | 不写 |
| 命中身份层 + 出现抵触 / 新扰动 | 写 `episodic_inbox.md` 或提交裁决，不直接改身份层 |
| 未命中身份层 | 进入 1b 分流 |

#### 1b · 信号分流

| 信号类型 | 例子 | 落点 |
|---|---|---|
| 单次校准信号 | 用户纠正、反对、正向确认、明显漏写 | `episodic_inbox.md` |
| 可复现情景模式 | 同类校准当天多次出现，边界清楚 | `episodic_memory.md` |
| 语义层可能击穿 | 启动注入 schema 被用户明确纠正 | 标记 weekly-review 复审 |
| 项目结论 / 阶段决策 | 项目框架定稿、悬置点、方向选择 | 项目主文档 / progress / 长期记忆，需按权限确认 |
| 普通低风险流水 | 当日做了什么 | `_本周.md` |

#### 1c · inbox 补捞

如果对话中出现校准信号，但实时未写入，可在 daily-review 末尾补写到 `episodic_inbox.md`：

```markdown
| JYYYYMMDD-001 | YYYY-MM-DD HH:mm | daily-review | 击穿 | 纠正 | 混合 | schema 指针 | 一句话观察 | 活动 |
```

补捞只追加文件末尾，不插入中段，不搬整段聊天。单纯补写 inbox 不写 `MEMORY_LOG`。

#### 1d · episodic_memory 聚合

只有满足以下条件，才从 inbox 合并或升格进 `episodic_memory.md`：

1. 能写成「情境→校准」或「情境→预期变化」。
2. 当天复现，或单条高风险信号足够明确。
3. 有 P轴 / C轴标注。
4. 不与 USER/SOUL、项目主结论、长期记忆 当前处境冲突。

写入使用情景层 1-3 星：

- 1 星：新候选。
- 2 星：当天或近几日复现。
- 3 星：等待 weekly-review 检查能否升 semantic。

daily-review 不写 `semantic_memory.md`、USER / SOUL / skill。

---

### 步骤 2 · 项目结论 / 阶段决策信号

本步骤替代旧版 `E 类信号（情景层）`。此处的 E 不再使用，避免和情景层文件混淆。

扫描本次对话是否产生：

- 结论确立。
- 悬置点明确。
- 阶段决策。
- 框架更新。
- 跨项目影响指针。

如有，生成确认表，等待用户确认后写入项目权威源：

| 信号 | 内容摘要 | 建议写入位置 | 确认 |
|---|---|---|---|
| 结论 / 悬置 / 决策 / 框架 | 一句话描述 | 项目主文档 / `_progress` / 长期记忆.md | 待确认 |

未经确认不写 C 级项目结论；已授权的项目推进流水按 S/N 规则处理。

---

### 步骤 3 · 更新 长期记忆.md 当前处境

条件：本次对话中主要矛盾或项目状态有实质变化。

有变化 → 覆盖更新 `长期记忆.md §当前处境`。无变化 → 跳过。

---

### 步骤 3.5 · 节点闭合兜底扫描

扫描本次对话是否存在已事实上闭合但未执行 close-node 的节点：

- 子问题解决。
- 决策拍板。
- 任务完成。
- 讨论收束并转入下一主题。

有 → 按 `close-node` skill 补跑。无 → 跳过。

---

### 步骤 4 · 写入 _本周.md 今日进展

在 `_本周.md §进展记录` 追加今日工作段。

格式沿用现有 `_本周.md`：

```markdown
### 周X YYYY-MM-DD

**项目名称**（`项目根目录路径`）
关联：`具体文件1.md` · `具体文件2.md`

- 今天做了什么。
- 确立了什么决策。
- 完成了什么，推进到哪里。
```

流水只记动作和决策，不复写理论推导细节。理论推导写项目文件，校准信号写记忆池。

---

### 步骤 5 · 废弃步骤

旧「写入人格档案」步骤废弃。身份层只走 v5 毕业路径：weekly-review + 用户 C 级 verdict。

---

### 步骤 6 · 写入 MEMORY_LOG（条件触发）

条件：本次会话发生记忆代谢：

- inbox 条目升为或合并进 `episodic_memory.md`。
- `episodic_memory.md` 修正 / 合并。
- `episodic_memory.md` 升星 / 降星 / 衰减 / 归档。
- `semantic_memory.md` 被明显击穿时，只写 MEMORY_LOG 复审标记；不改 `semantic_memory.md`。

满足 → 按 `MEMORY_LOG §操作日志` 模板追加一行。  
不满足 → 跳过。

inbox 只是新增条目时，默认不写 MEMORY_LOG；等升格、衰减、归档时再进入代谢记录。

---

### 步骤 6b · 写入 ITERATION_LOG（条件触发）

条件：发生系统架构、skill、协议、文件结构、hook 等变更。

满足 → 按 `ITERATION_LOG.md` 模板追加版本化条目。  
不满足 → 跳过。

---

### 步骤 6.5 · 周复盘（周日条件触发）

条件：逻辑日期为周日。

满足 → 执行 `weekly-review` v5 流程。  
不满足 → 跳过。

---

### 步骤 7 · 回应道别

全部流程完成后，用自然语言回应用户的告别语。

---

## 不做

- 不使用旧程序 / 语义双池。
- 不写 `semantic_memory.md`。
- 不把项目结论叫作 `E 类信号`。
- 不启动情景层注入。
- 不把普通具体事件强行抽象成 schema。
- 不动 hook / settings。

