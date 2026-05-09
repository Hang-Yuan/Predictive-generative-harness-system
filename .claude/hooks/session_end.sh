#!/bin/bash
INPUT="$(cat)"
if echo "$INPUT" | grep -qE '晚安|今天就到这里'; then
  printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"【会话结束信号】执行 daily-review skill 完整流程。权威源：~/.claude/skills/daily-review/SKILL.md"}}\n'
fi
