#!/bin/bash
# Usage: ./process_monitor.sh <process-name-or-PID> [interval]
# Writes timestamped entries to alerts.log when the process stops responding or disappears

set -u

TARGET="${1:-}"
INTERVAL="${2:-5}"
LOG_FILE="alerts.log"

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <process-name-or-PID> [interval]"
    exit 1
fi

if ! [[ "$INTERVAL" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: interval must be a positive integer."
    exit 1
fi

# 0 if it exists else 1
process_exists() {
    if [[ "$TARGET" =~ ^[0-9]+$ ]]; then
        kill -0 "$TARGET" 2>/dev/null
    else
        pgrep -x "$TARGET" >/dev/null 2>&1
    fi
}

# cleaning 
cleanup() {
    trap - INT TERM EXIT
    exit 0
}

trap cleanup INT TERM

echo "Monitoring: $TARGET"
echo "Polling interval: ${INTERVAL}s"
echo "Alerts will be written to: $LOG_FILE"
echo "Press Ctrl+C to stop."

# waiting for process to start
while ! process_exists; do
    sleep "$INTERVAL"
done

# waiting for it to stop 
while process_exists; do
    sleep "$INTERVAL"
done

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] ALERT: Process '$TARGET' has stopped or disappeared." >> "$LOG_FILE"

echo "[$TIMESTAMP] Process '$TARGET' has stopped. Alert logged to $LOG_FILE."
exit 0
