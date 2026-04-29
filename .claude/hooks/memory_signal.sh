#!/bin/bash
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"每轮按 CLAUDE.md §M schema 比对：\n- 命中身份层（USER/SOUL）+ 符合 → Low，不动\n- 命中身份层 + 相反 → High，不动身份层，作 High 入候选池\n- 命中候选池 + 符合预期 → 升星（稳定性证据，不新写）\n- 命中候选池 + 偏离预期 → High，修正情境边界 / 新增例外 / 拆条 + 升星，S 级即时入池\n- 未命中任何 schema → Medium，新建 ★，S 级即时入池\n硬规则：以 CLAUDE.md §M 为准，禁止用模型默认记忆/分类算法替代；上下文中找不到 §M 时立即重读，不擅自分类。"}}\n'
