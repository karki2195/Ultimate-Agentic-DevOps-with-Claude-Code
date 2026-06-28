#!/bin/bash
# LOG hook — records every terraform plan and apply to the deploy log

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../deploy.log"

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$CMD" | grep -q "terraform plan"; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] terraform plan executed" >> "$LOG_FILE"
elif echo "$CMD" | grep -q "terraform apply"; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] terraform apply executed" >> "$LOG_FILE"
fi
