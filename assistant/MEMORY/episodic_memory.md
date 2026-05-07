---
title: episodic_memory.md
type: memory-pool
layer: episodic
target_file: <ASSISTANT_ROOT>/MEMORY/episodic_memory.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# MEMORY episodic_memory

## 加载链（上下游）

**上游**：`CLAUDE.md §M · 记忆系统` — close-node / daily-review / weekly-review 需要维护情景记忆候选时读取。

**管辖文件（下游）：**
- `semantic_memory.md` — 候选达到语义层条件后升格。

**同级联动：**
- `episodic_inbox.md` — 候选来源。
- `00.memory_agent.md` — 升降星、衰减、毕业规则。
- `MEMORY_LOG.md` — 代谢流水。

---

## 文件职责

本文件保存 1-3 星的情景级候选 schema。它是程序型候选和语义型候选的统一池，用 `类型` 字段区分，不启动注入。

条目必须能写成可复现的“情境 -> 行动 / 预期”。只发生过的事实不进入本文件。

---

## 条目格式

### [条目标题]
- **强度**：★ / ★★ / ★★★
- **状态**：活动 / 复审 / 已归档
- **类型**：程序 / 语义 / 混合
- **创建日期**：YYYY-MM-DD
- **最后激活**：YYYY-MM-DD
- **提取次数**：0
- **触发情境**：[什么情形下该候选被激活]
- **行动模式**：[程序型或混合型必填；模型应执行什么动作]
- **预期**：[语义型或混合型必填；未来应如何被预测验证]
- **来源指针**：`episodic_inbox.md §J...` / `_progress/...` / `MEMORY_LOG.md §...`

---

## 升降规则

| 条件 | 动作 |
|---|---|
| 同一候选 7 天内再次被用户校准 | 强度 +1；更新最后激活 |
| 候选被明确击穿 | 重写触发情境 / 行动模式 / 预期；必要时新建竞争候选 |
| 连续 7 天无命中 | 强度 -1；状态可转复审 |
| 强度降到 0 | 状态改已归档，不物理删除 |
| 强度达到 ★★★ 且通过等价 schema 检查 | weekly-review 执行 semantic 升格；提取次数 +1 |

---

## 活动候选

（当前空）

---

## 已归档候选

（当前空）
