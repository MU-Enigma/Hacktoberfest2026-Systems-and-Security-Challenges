#!/bin/bash

BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}========== SYSTEM HEALTH REPORT ==========${RESET}"
echo -e " User     : ${GREEN}$(whoami)${RESET}"
echo -e " Hostname : ${GREEN}$(hostname)${RESET}"
echo

echo -e "${BOLD}${YELLOW}---------- Uptime and Usage ------------${RESET}"
echo -e "System has been up for: ${GREEN}$(uptime -p)${RESET}"
echo

echo -e "${BOLD}${YELLOW}Disk Usage:${RESET}"
echo "------------------------------------------"
df -h
echo

echo -e "${BOLD}${YELLOW}Memory Usage:${RESET}"
echo "------------------------------------------"
free -h
echo "=========================================="
