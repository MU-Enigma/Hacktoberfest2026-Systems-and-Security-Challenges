#!/bin/bash
# usage: ./process_monitor.sh <process-name-or-pid> [poll-interval]
# checks on a process and logs alerts to alerts.log if it drops

target="$1"
interval="$2"
logfile="alerts.log"

if [ -z "$target" ]; then
    echo "need a process name or pid to watch"
    echo "usage: $0 <process-name-or-pid> [poll-interval]"
    exit 1
fi

if [ -z "$interval" ]; then
    interval=2
fi

# handle ctrl+c so it shuts down
trap 'echo ""; echo "stopping monitor"; exit 0' SIGINT SIGTERM

echo "monitoring: $target (checking every ${interval}s, logging to $logfile)"
echo "press ctrl+c to stop"

isrunning() {
    if [[ "$target" =~ ^[0-9]+$ ]]; then
        kill -0 "$target" 2>/dev/null
        return $?
    else
        pgrep -x "$target" >/dev/null 2>&1 || pgrep -f "$target" >/dev/null 2>&1
        return $?
    fi
}

wasalive=0

if isrunning; then
    wasalive=1
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] process $target is currently running"
else
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] warning: process $target is not running right now"
    echo "[$timestamp] alert: process $target is not running" >> "$logfile"
fi

while true; do
    sleep "$interval"

    if isrunning; then
        if [ "$wasalive" -eq 0 ]; then
            timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            echo "[$timestamp] process $target is back up / running"
            echo "[$timestamp] info: process $target started or recovered" >> "$logfile"
            wasalive=1
        fi
    else
        timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        if [ "$wasalive" -eq 1 ]; then
            echo "[$timestamp] alert: process $target just stopped or crashed"
            echo "[$timestamp] alert: process $target stopped or crashed" >> "$logfile"
            wasalive=0
        else
            echo "[$timestamp] process $target is still down"
            echo "[$timestamp] alert: process $target is still down" >> "$logfile"
        fi
    fi
done
