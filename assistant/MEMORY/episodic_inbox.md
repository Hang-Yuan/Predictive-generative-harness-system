---
title: episodic_inbox.md
type: memory-inbox
layer: episodic
target_file: <ASSISTANT_ROOT>/MEMORY/episodic_inbox.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# MEMORY episodic_inbox

## 加载链（上下游）

**上游**：`CLAUDE.md §M · 记忆系统` — hook 判定需要记录实时校准信号时追加本文件。

**管辖文件（下游）：**
- `episodic_memory.md` — close-node / daily-review / weekly-review 聚合本文件条目后写入。

**同级联动：**
- `00.记忆区_agent.md` — 写入判定、保留期、升格规则。
- `MEMORY_LOG.md` — 升格、衰减、归档发生时记录。

---

## 文件职责

本文件只保存实时校准信号，不保存完整对话，不写长期结论，不启动注入。

写入判定：

```text
P轴=命中 且 C轴=中性 -> 不写
其他组合 -> 写入
```

P轴是观察与当前 schema 预测的关系：命中 / 击穿 / 未覆盖。
C轴是用户校准信号：正向确认 / 反对 / 纠正 / 中性。

---

## 写入方式

只允许追加到 `## 活动收件箱` 表格末尾；该活动表必须是文件最后一个块。示例：

```bash
cat >> "<ASSISTANT_ROOT>/MEMORY/episodic_inbox.md" <<'EOF'
| JYYYYMMDD-001 | YYYY-MM-DD HH:mm | 对话 | 击穿 | 纠正 | 混合 | schema 指针 | 一句话观察 | 活动 |
EOF
```

禁止：

- 新条目不得少于或多于 9 列；首尾必须有 `|`，观察记录内不得写入额外 `|` 字符。
- 不在 `## 活动收件箱`、表头、分隔行、数据行之间插入空行。
- 不用 Write 覆盖重建文件，不重建表头，不创建第二个活动收件箱。
- 不插入中段，不粘贴整段聊天。
- 追加前先读取目标文件，按当日已有 `JYYYYMMDD-序号` 选择该文件内下一个未占用编号。

---

## 字段

| 字段 | 含义 |
|---|---|
| ID | `JYYYYMMDD-NNN` 格式，YYYYMMDD 为逻辑日期，NNN 为当日序号 |
| 时间戳 | `YYYY-MM-DD HH:mm` 物理时间 |
| 触发场景 | 对话 / hook / close-node / daily-review / weekly-review |
| P轴 | 命中 / 击穿 / 未覆盖 |
| C轴 | 正向确认 / 反对 / 纠正 / 中性 |
| 类型 | 程序 / 语义 / 混合 |
| schema 指针 | 关联现有 schema（如有），无则填 `—` |
| 观察 | 一句话描述本次校准信号 |
| 状态 | 新条目统一填 `活动`；被 review 消耗的条目物理删行 |

---

## 保留期

未升格但仍需观察的条目保留为 `活动`；到期由 daily-review 或 weekly-review 判断迁入、继续观察或删除。

升格条件：在 episodic_memory 中能写成可复现的"情境→行动 / 预期"，则由 close-node / daily-review / weekly-review 聚合升格，原 inbox 行物理删除。L0 是高频写删层，不把已消耗条目长期堆成状态归档；行级写入 / 删除均为 N 级，执行后汇总，不问 C 级 verdict。

---

## 活动收件箱
| ID | 时间戳 | 触发场景 | P轴 | C轴 | 类型 | schema 指针 | 观察 | 状态 |
|---|---|---|---|---|---|---|---|---|
| J20260101-001 | 2026-01-01 10:00 | 对话 | 击穿 | 纠正 | 混合 | — | [示例条目：用户在某情境下纠正了 AI 的预期，对应 schema 待升格] | 活动 |
