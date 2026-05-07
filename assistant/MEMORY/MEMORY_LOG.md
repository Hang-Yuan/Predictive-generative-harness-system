---
title: 记忆系统日志
type: runtime-log
purpose: 记忆系统代谢记录（episodic / semantic 变更流水 + 记忆周复盘）
version: 5.0
---

# 记忆系统日志

## 加载链（上下游）

**上游（由谁加载本文件）：**
不在启动序列必须层。按需加载（审查记忆操作历史时）；daily-review / weekly-review 写入；启动序列可读尾部 N 行了解近期代谢节奏。

**同级联动：**
- `00.memory_agent.md` — 写入格式 / 代谢规则 / 判断锚点（规则权威）
- `episodic_inbox.md` / `episodic_memory.md` / `semantic_memory.md` — 当前运行记忆文件
- `_archive/semantic_archive.md` — semantic 条目证据 / 命中 / 演化记录
- `ITERATION_LOG.md` — 架构 / skill / hook / 协议变更走 ITERATION_LOG
- `长期记忆.md` — 当前处境快照 + 跨周工作节点 + 周工作复盘

---

## 关于此文件

**记忆日志**只追踪记忆系统自身的代谢：inbox 消耗、episodic 升降 / 衰减 / 归档、semantic 升降 / 毕业候选，以及每周的记忆系统复盘。

**不写入：**
- 系统架构变更 / 技能创建重写 / 协议迭代 / 人格文件变动 → `ITERATION_LOG.md`
- 每次对话的工作进展 → `_本周.md`
- 跨周工作节点 / 周工作复盘 → `长期记忆.md`

---

## 机制要点（v5）

| 机制 | 说明 |
|---|---|
| 实时信号 | 除 P=命中 且 C=中性 外，写入 `episodic_inbox.md` |
| 情景候选 | close-node / daily-review 聚合 inbox，生成 1-3 星 `episodic_memory.md` |
| 语义升格 | weekly-review 将稳定 3 星候选升入 `semantic_memory.md` |
| 启动注入 | `semantic_memory.md` 最多保留 8 条 4-6 星 schema |
| 毕业 | 6 星 + 跨周稳定 + 用户 C 级确认 → USER / SOUL / skill |
| 默认遗忘 | 未复现、未升格、低价值条目自然衰减或归档 |

---

## 操作日志

YYYY-MM-DD | 初始化：v5 记忆系统模板建立

---

## 周复盘

（空 —— 周复盘完成后按模板追加。）

---

## 毕业归档

（空 —— semantic 条目毕业时，完整原条目 + 剥壳后净版副本写入此处。）
