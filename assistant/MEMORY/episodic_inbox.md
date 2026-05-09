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

只允许追加到文件末尾。使用 Bash 追加：

```bash
cat >> "<ASSISTANT_ROOT>/MEMORY/episodic_inbox.md" <<'EOF'
| JYYYYMMDD-001 | YYYY-MM-DD HH:mm | 对话 | 击穿 | 纠正 | 混合 | schema 指针 | 一句话观察 | 活动 |
EOF
```

禁止：

- 不用 Edit 改写整份文件。
- 不用 Write 覆盖重建文件。
- 不插入中段。
- 不粘贴整段聊天。

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
| 状态 | 活动 / 已升格 / 已衰减 |

---

## 保留期

未升格的条目保留 7 天；到期由 daily-review 或 weekly-review 标记 `已衰减`，不物理删除。

升格条件：在 episodic_memory 中能写成可复现的"情境→行动 / 预期"，则由 close-node / daily-review / weekly-review 聚合升格，原条目状态改 `已升格`。

---

## 活动收件箱

| ID | 时间戳 | 触发场景 | P轴 | C轴 | 类型 | schema 指针 | 观察 | 状态 |
|---|---|---|---|---|---|---|---|---|
| J20260101-001 | 2026-01-01 10:00 | 对话 | 击穿 | 纠正 | 混合 | — | [示例条目：用户在某情境下纠正了 AI 的预期，对应 schema 待升格] | 活动 |
