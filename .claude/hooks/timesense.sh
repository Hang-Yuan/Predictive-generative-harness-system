#!/bin/bash
_W=("" "周一" "周二" "周三" "周四" "周五" "周六" "周日")
NOW="$(date '+%Y-%m-%d %H:%M') ${_W[$(date +%u)]}"
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"当前时间：%s（每条回复第一行输出此时间，code格式单行）"}}\n' "$NOW"
