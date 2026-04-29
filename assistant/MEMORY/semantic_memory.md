---
title: MEMORY/semantic_memory.md
type: memory-pool
layer: semantic
version: 3.2
created: YYYY-MM-DD
description: 语义层候选池——用户偏好 / 认知框架 / 价值判断。★★★★★ 毕业至 USER.md。
---

# 语义层候选池（Semantic Memory）

候选池，不是仓库。

## 加载链（上下游）

- **上游**：`CLAUDE.md §B 启动序列` 步骤 3
- **同级联动**：
  - `00.memory_agent.md` — 写入格式 / 代谢规则 / 判断锚点（规则权威）
  - `procedural_memory.md` — 程序层候选池
  - `MEMORY_LOG.md` — 代谢流水
  - `_archive/semantic_archive.md` — 语义层条目详记（证据 / related / 日期 / 演化记录）
  - `USER/USER.md` — 毕业目标

> 所有写入/代谢操作前先读 `00.memory_agent.md`。

---

## 条目格式

每条条目是一个 **schema**——对用户行为/判断的概率性预测，可被后续观察证实或证伪。主池只保留运行时需要常驻注入的字段；发现日期 / 证据 / related / 演化记录写入 `_archive/semantic_archive.md`。

| 字段 | 说明 |
|---|---|
| **强度** | ★–★★★★★，星级即稳定度 |
| **情境** | 什么情形下这条 schema 会被测试 |
| **预期** | 在此情境下用户大概率如何反应（1-3 条概率性预测） |
| **来源指针** | 指向 archive 中该条目的证据详记 |

---

## 当前条目

### 示例：用户偏好可反证推理
- **强度**：★
- **情境**：讨论方案、理论、系统设计或高影响决策时
- **预期**：
  - 用户更需要可检验的反例和边界，而不是直接附和
  - 若方案成立，应说明成立边界；若不成立，应给替代结构
- **来源指针**：`_archive/semantic_archive.md §S00 · 示例：用户偏好可反证推理`

> 以上为占位示例，不是从任何真实用户数据迁移而来。正式使用时可删除或替换。