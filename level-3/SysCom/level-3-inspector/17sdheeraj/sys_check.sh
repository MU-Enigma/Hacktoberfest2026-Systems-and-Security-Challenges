#!/bin/bash
if [ -t 1 ]; then BOLD="\033[1m"; CYAN="\033[36m"; GREEN="\033[32m"; YELLOW="\033[33m"; BLUE="\033[34m"; RESET="\033[0m"; else BOLD=""; CYAN=""; GREEN=""; YELLOW=""; BLUE=""; RESET=""; fi
echo -e "${BOLD}${CYAN}====================================================${RESET}"
echo -e "${BOLD}${CYAN}                SYSTEM HEALTH REPORT                ${RESET}"
echo -e "${BOLD}${CYAN}====================================================${RESET}"
echo -e "${BOLD}${BLUE} Hostname       :${RESET} ${GREEN}$(hostname)${RESET}"; echo -e "${BOLD}${BLUE} Current User   :${RESET} ${GREEN}$(whoami)${RESET}"; echo
echo -e "${BOLD}${YELLOW} System Uptime:${RESET}"; echo -e "   Pretty Uptime  : $(uptime -p)"; echo -e "   Load & Users   : $(uptime)"; echo
echo -e "${BOLD}${YELLOW} Memory Usage:${RESET}"; echo "----------------------------------------------------"; free -h; echo
echo -e "${BOLD}${YELLOW} Disk Usage:${RESET}"; echo "----------------------------------------------------"; df -h; echo
echo -e "${BOLD}${CYAN}====================================================${RESET}"; echo -e "${BOLD}${GREEN}               Report Complete                      ${RESET}"; echo -e "${BOLD}${CYAN}====================================================${RESET}"