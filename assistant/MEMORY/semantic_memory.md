---
title: semantic_memory.md
type: memory-pool
layer: semantic
target_file: <ASSISTANT_ROOT>/MEMORY/semantic_memory.md
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# MEMORY semantic_memory

## 加载链（上下游）

**上游**：`CLAUDE.md §B · 启动序列` — 每次启动读取本文件启动注入组。

**管辖文件（下游）：**
- `_archive/semantic_archive.md` — 本文件所有证据、命中、演化记录的详记。

**同级联动：**
- `episodic_memory.md` — semantic 条目升格来源或降级去处。
- `00.记忆区_agent.md` — 升降、衰减、毕业规则。
- `MEMORY_LOG.md` — 记忆代谢流水。
- `USER/USER.md` / `SOUL/persona/persona_SOUL.md` / `~/.claude/skills/` — 毕业目标。

---

## 文件职责

本文件只保留启动和 compact 后需要注入的高价值 schema。主文件极简；证据、来源、命中记录、复现次数、演化记录全部写入 `_archive/semantic_archive.md`。

启动注入组最多 8 条。

---

## 条目格式

```
### [条目标题]
- **强度**：★★★★ / ★★★★★ / ★★★★★★候选
- **状态**：启动注入 / 备用 / 需要修订 / 毕业候选 / 已毕业
- **类型**：程序 / 语义 / 混合
- **预测情境**：[何时调用这条 schema]
- **行动预期**：[模型应如何预测或行动]
- **证据指针**：`_archive/semantic_archive.md §[条目ID]`
```

---

## 升降规则

| 条件 | 动作 |
|---|---|
| episodic_memory 候选达 ★★★ 且通过等价 schema 检查 | 升格写入本文件，初始 ★★★★ |
| 整周无命中 | 强度 -1 |
| 被击穿并纠正 | 标 `需要修订`；weekly-review 重写或降级 |
| 强度降到 ★★★ | 移出启动注入，写回 `episodic_memory.md` |
| 达到 6 星且跨周稳定 | 生成毕业候选，等待 C verdict |

启动注入组超过 8 条时，按优先级（高风险约束 > 强度 > 近期命中 > 处境相关 > 未被身份层覆盖）将最低项退回 `episodic_memory.md` 或备用组。

---

## 启动注入组

> 初始为空。由 weekly-review 从 episodic_memory 升格写入。

<!-- 启动注入组示例（用户实际有 schema 时按此格式填入）：

### [示例 schema 标题：某类情境下的稳定预测]
- **强度**：★★★★
- **状态**：启动注入
- **类型**：程序
- **预测情境**：[何时调用]
- **行动预期**：[如何预测或行动]
- **证据指针**：`_archive/semantic_archive.md §S001`

-->

---

## 备用组

> 启动注入组满载时，被退出的低优先级 schema 暂存于此。初始为空。

---

## 毕业候选

> 6 星候选 + 跨周稳定 + 用户 C verdict 后毕业到 USER / persona_SOUL / skill。初始为空。
