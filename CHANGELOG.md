# CHANGELOG

Predictive Generative Harness for Claude Code 的模板版本迭代记录。

## 版本号规则

- `v5.x.x` 起为 PGH 5.0 新架构。
- 5.0 之前版本不再作为升级链追溯；旧版用户建议重新部署 5.0。
- 每次发布只记录公开模板结构、入口协议、初始化流程、hook / skill / assistant 骨架变化。

## v5.0.1 · 2026-05-14 · L0 inbox 默认遗忘修订

本次是记忆系统可靠性修订。重点不是 hook 9 列模板本身，而是防止 AI / skill 在补捞、close-node、daily-review、weekly-review 时把 L0 写坏或把已消耗条目堆成状态归档。

### 修订内容

- `assistant/MEMORY/episodic_inbox.md` 明确：新条目必须严格 9 列、首尾有 `|`、不得断表、不得重建表头、不得创建第二个活动收件箱。
- `assistant/MEMORY/00.记忆区_agent.md` 明确：L0 是高频写删层；review 消耗后默认物理删除原 inbox 行，只有仍待观察的信号保留为 `活动`。
- `close-node` / `daily-review` / `weekly-review` 三个 skill 同步写入纪律和默认遗忘规则。
- `memory_signal` hook 增加写入纪律提醒：追加前先读目标 inbox，选择同一物理文件内当日下一个未占用编号。
- 权限定级明确：L0 inbox 行级写入 / 行级物理删除均为 N 级动作，执行后汇总，不问 C 级 verdict；删除整份文件或非 inbox 历史证据仍为 C 级。

### 迁移提示

已部署用户升级时，先检查 `assistant/MEMORY/episodic_inbox.md` 是否存在少列行、重复 ID 或活动表中间空行；修正后再继续 review。不要把 L0 当长期归档区使用。

## v5.0.0 · YYYY-MM-DD · PGH 5.0 新起点

5.0 是新起点，不再追溯旧版本历史。

### 结构

- 采用全中文 assistant 骨架。
- `USER/` 初始只保留 `USER.md`；子文件由 §0 初始化访谈后动态生成。
- `§0` 改为“基础信息 + 故事访谈 + AI 拆解建文件”的首次初始化流程。
- 新增 `§-1` 部署 / 迁移协议：用户把 GitHub 链接发给 Claude Code 后，由 AI 自己完成部署、迁移、验证和自删。
- 移除一键部署脚本，不再提供自动脚本升级路径。

### 记忆与项目

- 保留 `长期记忆.md`、`00 专注区/`、`01 项目区/`、`MEMORY/`、`SOUL/persona/` 作为最小可运行骨架。
- MEMORY 文件保留模板和示例条目，不携带任何真实用户历史。
- 项目区只保留 portfolio agent 模板，真实项目由初始化或后续会话创建。

### Hooks

- 保留时间感知、记忆信号、思考协议、会话上下文检查、会话结束整理等 hooks。

### 同步建议

5.0 之前部署的用户不再支持自动升级路径。请重新部署 PGH 5.0，让 AI 按 `§-1` 检测旧系统并迁移已有内容。
