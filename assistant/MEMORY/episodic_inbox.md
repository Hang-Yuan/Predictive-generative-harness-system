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
- `00.memory_agent.md` — 写入判定、保留期、升格规则。
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

禁止：不用 Edit 改写整份文件；不用 Write 覆盖重建文件；不插入中段；不粘贴整段聊天。

---

## 字段

| 字段 | 说明 |
|---|---|
| 编号 | `JYYYYMMDD-序号`。 |
| 时间 | 物理时间，本地时区。 |
| 来源 | 对话 / close-node / daily-review / weekly-review / 手动补录。 |
| P轴 | 命中 / 击穿 / 未覆盖。 |
| C轴 | 正向确认 / 反对 / 纠正 / 中性。 |
| 类型提示 | 程序 / 语义 / 混合 / 未定。 |
| schema 指针 | 被命中、击穿或缺失的 schema；没有则写 `未覆盖`。 |
| 观察记录 | 一句话说明发生了什么校准。 |
| 处理状态 | 活动 / 已消耗 / 已升情景记忆 / 已衰减 / 已归档。 |

---

## 活动收件箱

| 编号 | 时间 | 来源 | P轴 | C轴 | 类型提示 | schema 指针 | 观察记录 | 处理状态 |
|---|---|---|---|---|---|---|---|---|
