---
title: MEMORY/procedural_memory.md
type: memory-pool
layer: procedural
version: 3.2
created: YYYY-MM-DD
description: 程序层候选池——AI 行动手册（情境→行动）。★★★★★ 毕业至 SOUL/persona/persona_SOUL.md。
---

# 程序层候选池（Procedural Memory）

候选池，不是仓库。

## 加载链（上下游）

- **上游**：`CLAUDE.md §B 启动序列` 步骤 3
- **同级联动**：
  - `00.memory_agent.md` — 写入格式 / 代谢规则 / 判断锚点（规则权威）
  - `semantic_memory.md` — 语义层候选池
  - `MEMORY_LOG.md` — 代谢流水
  - `_archive/procedural_archive.md` — 程序层条目详记（证据 / related / 日期 / 演化记录）
  - `SOUL/persona/persona_SOUL.md` — 毕业目标

> 所有写入/代谢操作前先读 `00.memory_agent.md`。

---

## 条目格式

每条条目是一个 **script**——AI 遇到特定情境时的行动规则，附带预期后效（用于验证规则是否成立）。主池只保留运行时需要常驻注入的字段；发现日期 / 证据 / related / 演化记录写入 `_archive/procedural_archive.md`。

| 字段 | 说明 |
|---|---|
| **强度** | ★–★★★★★，星级即稳定度 |
| **触发情境** | 什么情形下这条规则被激活 |
| **行动模式** | AI 应执行的动作 |
| **预期后效** | 执行此行动后预期用户/世界如何反应（用于验证规则有效性） |
| **来源指针** | 指向 archive 中该条目的证据详记 |

---

## 当前条目

### 示例：先确认授权再写共享正史
- **强度**：★
- **触发情境**：需要修改 USER / SOUL / 长期记忆 / 项目主文档等共享正史文件时
- **行动模式**：先确认授权；未授权时生成拟写入包或写入通信区，不直接改共享正史
- **预期后效**：用户能清楚看到写入边界，系统不会因越权写入污染权威源
- **来源指针**：`_archive/procedural_archive.md §P00 · 示例：先确认授权再写共享正史`

> 以上为占位示例，不是从任何真实用户数据迁移而来。正式使用时可删除或替换。

---

## 别名对照表

| 用户说法 | 实际指代 | 场景 |
|---|---|---|
| [示例] | [实际指代] | [最近讨论中] |