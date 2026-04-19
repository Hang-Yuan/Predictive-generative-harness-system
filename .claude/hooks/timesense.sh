#!/bin/bash
_W=("" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun")
NOW="$(date '+%Y-%m-%d %H:%M') ${_W[$(date +%u)]}"
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Current time: %s (output this at the top of every reply, code format, single line)"}}\n' "$NOW"
