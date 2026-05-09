# Predictive Generative Harness for Claude Code

PGH 5.0 是一套给 Claude Code 使用的个人长期协作骨架。它把"用户档案 / AI persona / 长期记忆 / 周工作台 / 项目区 / 记忆代谢 / hooks / skills"做成一套可部署的 Markdown 文件结构，让 Claude Code 在每次会话启动时自动加载、按规则写入、跨会话保持上下文。

**与 Claude Code 默认行为的差别**：默认情况下 Claude Code 是无状态的；PGH 把长期上下文外置成结构化文件，让 Claude 启动时沿加载链读取，逐消息通过 hook 获得提醒，再由 skill 把值得保留的信息分类写回本地知识库。

> 最近更新见 [CHANGELOG.md](./CHANGELOG.md)。
> Core / Adapter 分流细节见 [docs/核心分流.md](./docs/核心分流.md)。

---

## 架构

PGH 5.0 的文件分三类，**部署 / 阅读 / 写入** 角色不同：

### 一、骨架文件（部署时复制到本地，AI 启动时读取）

这部分是 PGH 的 **运行时骨架**，每个 Claude Code 会话启动都会读取它们：

| 路径 | 角色 | 读 / 写 |
|---|---|---|
| `.claude/CLAUDE.md` | 全局指令主控（启动序列 / 系统原则 / 行为规则 / 记忆系统 / 故障恢复）| AI 启动必读，不写 |
| `.claude/settings.json` | hooks 配置 | AI 启动读取，不写 |
| `.claude/hooks/*.sh` | 逐消息 hook（时间感知 / 记忆信号 / 思考协议 / 节点收尾 / 会话结束）| AI 触发，不写 |
| `.claude/skills/*/SKILL.md` | 工作流（daily-review / weekly-review / close-node / write-progress / create-project / new-file / week-sync / manage-research-reference）| AI 按情境调用，不写 |
| `.claude/agents/general-search-agent.md` | 通用检索 sub-agent | AI 调用，不写 |
| `assistant/00 专注区/00.专注区_agent.md` | 专注区规则 agent | AI 按需读，不写 |
| `assistant/01 项目区/00.项目区_agent.md` | 项目区规则 agent | AI 按需读，不写 |
| `assistant/MEMORY/00.记忆区_agent.md` | 记忆系统规则 agent | AI 按需读，不写 |

### 二、用户内容文件（部署时为空模板，AI 在初始化访谈和后续会话中动态写入）

这部分是 **用户专属内容**，PGH 部署时只提供空骨架；首次初始化访谈和后续会话中由 AI 动态生成：

| 路径 | 角色 | 何时写入 |
|---|---|---|
| `assistant/USER/USER.md` | 用户身份主档 | §0 阶段 1 基础信息访谈后写入；后续 weekly-review 毕业补充认知模式 / 协作注意事项 |
| `assistant/USER/[子文件].md` | USER 子文件（个人经历 / 心理画像 / 信念体系 / 兴趣起源 等）| §0 阶段 3 AI 拆解访谈结果后**动态决定建什么**（不预设数量 / 名字） |
| `assistant/SOUL/persona/persona_SOUL.md` | AI persona | §0 阶段 1.2 写入身份 / 风格；行为模式由 weekly-review 从语义记忆毕业 |
| `assistant/长期记忆.md` | 当前处境 / 时间轴 / 详细周录 | §0 阶段 1.3 写入当前处境；后续 daily-review / weekly-review 维护 |
| `assistant/00 专注区/_本周.md` | 当前周工作台（任务 / 进展 / 产出）| daily-review / weekly-review / week-sync 维护 |
| `assistant/01 项目区/[项目]/` | 用户项目目录 | §0 阶段 1.3 + 后续会话调 `create-project` skill 建 |
| `assistant/MEMORY/episodic_inbox.md` | 实时校准信号收件箱 | hook 触发后由 AI 追加 |
| `assistant/MEMORY/episodic_memory.md` | 1-3 星情景候选 | close-node / daily-review / weekly-review 写入 |
| `assistant/MEMORY/semantic_memory.md` | 4-6 星启动注入 schema | weekly-review 升格写入 |
| `assistant/MEMORY/MEMORY_LOG.md` | 记忆代谢流水 | 升格 / 降星 / 衰减 / 归档时由 review skill 写入 |
| `assistant/ITERATION_LOG.md` | 架构 / skill / 协议变更日志 | 变更发生时由 review skill 写入 |

### 三、参考文档（部署时复制，用户和 AI 都按需阅读）

| 路径 | 角色 |
|---|---|
| `README.md` | 本文件 |
| `CHANGELOG.md` | 模板版本迭代记录 |
| `docs/核心分流.md` | PGH Core 与 Claude Adapter 分流说明 |

---

## 部署

把以下指令发给 Claude Code：

```text
这是 PGH 5.0 链接 [GitHub URL]，帮我装到本机。如果我已经有旧 PGH 系统，把我已有的内容迁移过来。
```

AI 会按 `.claude/CLAUDE.md §-1 部署 / 迁移协议` 自己完成：

1. 拉取或下载 PGH 5.0 仓库到临时目录
2. 复制骨架文件到 `~/.claude/`，复制用户内容空模板到指定的 `<ASSISTANT_ROOT>/`
3. 替换占位符（assistant 路径 / Claude 配置目录路径等）
4. 检测是否有旧 PGH 系统：有则备份并迁移已有用户内容到 5.0 结构；无则保留 §0 启动首次初始化访谈
5. 完成后删除 §-1 节，进入 §0 初始化或正常启动序列

PGH 不管 Claude Code 本身的安装——上游官方安装完后再把上面的指令发给 Claude Code。

---

## 首次初始化

部署完成后，Claude Code 启动会读到 `.claude/CLAUDE.md` 顶部的 `§0 初始化引导`。

初始化分三段，AI 主动引导，不需要你手填模板：

- **阶段 1 · 基础信息（5 分钟，必做）**
  - 用户档案：称呼 / 语言 / 时区 / 主要用途 / 隐私边界
  - AI 助手期望：AI 名字 / 风格期望
  - 当下处境 + 项目导入：1-3 个月重点 / 当下项目 / 本周主线 / 近期截止

- **阶段 2 · 故事访谈（30 分钟左右，必做）**
  - AI 主动引导你讲受教育与起点 / 工作与项目轨迹 / 自我认知 / 价值与信念 / 行为模式
  - 你可以让 AI 直接读你的工作文件夹路径或电脑上的相关内容
  - AI 边听边追问，鼓励你发散

- **阶段 3 · AI 拆解 + 动态建文件 + 用户预览**
  - AI 拆解访谈内容 → 动态决定建几个 USER 子文件、叫什么名（不预设数量 / 名字）
  - 给你写入预览，你确认后写入

完成后 AI 删除 `§0` 整节，下次启动进入正常启动序列。

---

## Hook

| Hook | 触发 | 作用 |
|---|---|---|
| `timesense.sh` | 每条消息 | 注入当前时间 |
| `memory_signal.sh` | 每条消息 | 提示 P/C 两轴记忆信号判断 |
| `thinking_protocol.sh` | 每条消息 | 注入四步思考协议 |
| `session_context_check.sh` | 每条消息 | 提示节点收尾和项目加载 |
| `session_end.sh` | 告别语 | 触发 daily-review |

---

## 记忆架构

PGH 5.0 使用三层记忆骨架：

- `episodic_inbox.md`：新近校准信号收件箱，hook 触发追加
- `episodic_memory.md`：1-3 星情景级候选 schema，close-node / daily-review / weekly-review 写入
- `semantic_memory.md`：4-6 星稳定语义 schema，启动注入；weekly-review 升格写入

`MEMORY_LOG.md` 只记录记忆系统代谢；项目结论写项目主文档；当前处境写 `长期记忆.md`。

毕业路径：6 星候选 + 跨周稳定 + 用户 C 级 verdict → `USER/` / `SOUL/persona/persona_SOUL.md` / `~/.claude/skills/`。

---

## 自定义

PGH 5.0 优先让 AI 通过初始化和后续会话动态维护文件。需要手动改时：

- 改 `assistant/` 中的 Markdown，让 Claude Code 在下次会话核加载链 / frontmatter / 隐私残留
- 新增 sub-agent：在 `.claude/agents/` 自行新建（默认只内置 `general-search-agent`，需要其他领域如学术研究 / PhD 申请 / 商业项目等由用户自建）
- 调整记忆阈值：改 `assistant/MEMORY/00.记忆区_agent.md`
- 调整 hook：改 `.claude/hooks/*.sh`
- 新增 skill：在 `.claude/skills/` 新建目录 + `SKILL.md`

---

## 设计原则

- **加载链导航，不靠模型硬记忆**：每个文件声明上游 / 下游 / 同级联动
- **单一权威源**：每条信息只在一个地方定义，其他地方只放摘要和指针
- **默认遗忘**：低置信信号自然消失，高价值信号复现后才上行
- **身份层需确认**：USER / SOUL / skill 的稳定改动必须经过明确授权
- **运行时分流**：PGH Core 不绑定 Claude；`.claude/` 只负责 Claude 接入

---

## 许可

MIT。
</content>
