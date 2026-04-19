---
title: 记忆系统日志
type: runtime-log
purpose: 记忆系统代谢记录（程序/语义候选池变更流水 + 记忆周复盘）
version: 3.0
---

# 记忆系统日志

## 加载链

**上游：**
不在启动必读序列。按需加载（审计记忆操作历史时）；由 daily-review 步骤 6 / weekly-review 步骤 7 写入。

**同级联动：**
- `00.memory_agent.md` — 写入格式 / 代谢规则 / 判断锚点（规则权威）
- `procedural_memory.md` / `semantic_memory.md` — MEMORY_LOG 记录代谢流水，候选池两文件存当前条目
- `ITERATION_LOG.md` — 架构/技能/协议/人格变更走 ITERATION_LOG（版本化详细条目），MEMORY_LOG 只管记忆代谢
- `LTM.md` — 当前处境快照 + 跨周工作节点 + 周工作复盘走 LTM，MEMORY_LOG 只管记忆系统本身

---

## 关于本文件

**记忆日志** 只追踪 **候选池代谢** —— 程序/语义条目的新增/升星/降星/毕业/删除，加上每周的记忆系统复盘。

**何时写入：**
- 任何包含候选池变更的会话 → 在 `§操作日志` 末尾追加一行
- 周复盘完成后 → 在 `§周复盘` 末尾追加完整周复盘条目

**格式：**
- 操作日志：一行简记（`YYYY-MM-DD | [类型]：[简要描述]`），**无 ## 前缀**
- 周复盘：H3 标题（`### YYYY-WNN 周复盘（YYYY-MM-DD）`），模板见 weekly-review skill

---

## 机制速查（v3 schema prediction）

| 机制 | 说明 |
|---|---|
| 入池 | High（命中+偏离）→★★★；Medium（未命中）→★；Low（命中+符合）→不写 |
| 升星 | 同方向再次观察 → 星 +1 |
| 降星 / 休眠 | weekly-review 扫描：N 周无命中 → -1 星；0 星后持续无命中 → 删除 |
| 毕业（★★★★★） | 程序 → `SOUL/persona/persona_SOUL.md`；语义 → `USER/USER.md`；需 weekly-review 确认 + 跨周稳定 |
| 冲突 | 新条目与已有矛盾 → N 级告知用户，不静默覆盖 |

---

## 操作日志

（条目会随记忆代谢发生在此追加。）

---

## 周复盘

（周复盘条目会在此追加。）
