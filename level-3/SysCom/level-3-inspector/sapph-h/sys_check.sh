echo "===== SYSTEM HEALTH REPORT ====="
echo "Hostname : $(hostname)"
echo "User     : $(whoami)"
echo ""
echo "--- Uptime ---"
uptime
echo ""
echo "--- Disk Usage ---"
df -h
echo ""
echo "--- Memory Usage ---"
free -h
