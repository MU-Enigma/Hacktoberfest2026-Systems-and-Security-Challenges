#!/bin/bash

# System Health Inspector
# Reports basic information about the current machine.

echo "=================================="
echo "       SYSTEM HEALTH REPORT"
echo "=================================="

# Display hostname and current user
echo "Hostname : $(hostname)"
echo "User     : $(whoami)"

# Display system uptime
echo ""
echo "--- System Uptime ---"
uptime

# Display disk usage in human-readable format
echo ""
echo "--- Disk Usage ---"
df -h

# Display RAM usage in human-readable format
echo ""
echo "--- Memory Usage ---"
free -h

echo ""
echo "======= END OF REPORT ======="
