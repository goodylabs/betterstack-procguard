#!/usr/bin/env bash

###################################
#                                 #
#  ProcGuard Watchdog v 1.1       #
#                                 #
#  Copyright goodylabs 2025-2026  #
#                                 #
###################################


function print_usage {
  echo "Usage:"
  echo "$0 [HEARTBEAT_ID] [INTERVAL]"
  echo ""
}

if [ "x$1" == "x" ]; then
  echo "Missing param HEARTBEAT_ID! "
  echo ""
  print_usage
  exit 1
fi

if [ "x$1" == "x--help" ]; then
  echo ""
  print_usage
  exit 1
fi

HEARTBEAT_ID="${1}"
INTERVAL="${2:-60}"

if [ "x$2" == "x" ]; then
  echo "[INFO] Missing param INTERVAL! Setting default to ${INTERVAL} ..."
fi

HEARTBEAT_SUCCESS_URL="https://uptime.betterstack.com/api/v1/heartbeat/${HEARTBEAT_ID}"
HEARTBEAT_FAIL_URL="https://uptime.betterstack.com/api/v1/heartbeat/${HEARTBEAT_ID}/fail"
CONFIG_FILE="$HOME/.config/procguard-watchdog.inc"
CONFIG_FILE_LINE_COUNT=0

AWK=`which awk`
CURL=`which curl`
DATE=`which date`
GREP=`which grep`
HEAD=`which head`
HOSTNAME=`which hostname`
IP=`which ip`
PS=`which ps`
SLEEP=`which sleep`
SORT=`which sort`
UNAME=`which uname`
WC=`which wc`

declare -A WHITELIST

function current_time {
  ${DATE} "+%Y-%m-%d %H:%M:%S"
}

echo "$(current_time) [INIT] Getting data about machine ..."

OS=`${UNAME}`

HOST_NAME=`${HOSTNAME}`
HOST_IP="unknown"

if [ "x${OS}" == "xLinux" ]; then
  HOST_IP=`${IP} a | ${GREP} "eth0" | ${GREP} "inet " | ${HEAD} -1 | ${AWK} '{print $2;}'`
elif [ "x${OS}" == "xDarwin" ]; then
  HOST_IP=`${IP} a | ${GREP} -A 3 "en0" | ${GREP} "inet " | ${HEAD} -1 | ${AWK} '{print $2;}'`
fi

echo -e "\tHost name: ${HOST_NAME}, primary IP: ${HOST_IP}"

echo "$(current_time) [INIT] Gathering facts about processes ..."

INIT_PROCESSES=$(${PS} -efwww | ${GREP} -v "\[.*\]$" | ${AWK} '{print $8}' | ${SORT} -u)

while read -r proc; do
  WHITELIST["$proc"]=1
done <<< "$INIT_PROCESSES"

if [[ -f "$CONFIG_FILE" ]]; then
  echo "$(current_time) [INIT] Fetching process whitelist from $CONFIG_FILE"
  while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue # skip empty lines and commented out lines
    WHITELIST["$line"]=1
    ((CONFIG_FILE_LINE_COUNT++))
  done < "$CONFIG_FILE"
else
  echo "$(current_time) [INIT] No additional whitelist in $CONFIG_FILE (OK)"
fi

if [ $CONFIG_FILE_LINE_COUNT -gt 0 ]; then
  echo -e "$(current_time) [INIT] \tRead ${CONFIG_FILE_LINE_COUNT} lines from ${CONFIG_FILE} ..."
fi

echo "$(current_time) [INIT] Process dictionary loaded. There are ${#WHITELIST[@]} processes in the dictionary."

while true; do
  CURRENT_PROCS=$(${PS} -efwww | ${GREP} -v "\[.*\]$" | ${AWK} '{print $8}' | ${SORT} -u)

  echo "$(current_time) [INFO] Checking current process list..."
  ${CURL} -s -X GET "${HEARTBEAT_SUCCESS_URL}" >/dev/null 2>&1

  while read -r current; do
    shortened_current_in_node_modules="node_modules/${current##*/node_modules/}"
    shortened_current_in_snap="/${current#*/snap/certbot/*/}"

    if [[ -z "${WHITELIST["$current"]}" ]] && [[ -z "${WHITELIST["$shortened_current_in_node_modules"]}" ]] && [[ -z "${WHITELIST["$shortened_current_in_snap"]}" ]]; then
      echo "$(current_time) [ALERT] New process: $current"

      error_message="Unknown process ${current} on machine ${HOST_NAME} (${HOST_IP})"
      echo "Error message: ${error_message}"

      ${CURL} -s -X POST -d "${error_message}" "$HEARTBEAT_FAIL_URL" >/dev/null 2>&1
    fi
  done <<< "$CURRENT_PROCS"

  ${SLEEP} "$INTERVAL"
done
