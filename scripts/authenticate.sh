#!/usr/bin/env bash

set -euo pipefail

trap 'rm -f loginResult.json' EXIT

printf -v red '\033[0;31m'
printf -v yellow '\033[0;33m'
printf -v green '\033[0;32m'
printf -v bold '\033[1m'
printf -v reset '\033[0m'

echo "${yellow}${bold}------------------------------------------------------------------------------------------${reset}"
echo "${yellow}${bold}Authenticate org 🔒${reset}"
echo "${yellow}${bold}------------------------------------------------------------------------------------------${reset}"

sf_command=("sf" "org" "login" "sfdx-url" "--sfdx-url-stdin" "--json")

if [ "${ALIAS}" != "" ]; then
    sf_command+=("--alias" "${ALIAS}")
fi

if [ "${SET_DEFAULT_USERNAME}" == "true" ]; then
    sf_command+=("--set-default")
fi

if [ "${SET_DEFAULT_DEVHUB_USERNAME}" == "true" ]; then
    sf_command+=("--set-default-dev-hub")
fi

echo "Authenticating Salesforce org..."

if [ -z "${AUTH_URL}" ]; then
    echo "::error title=Failed to authenticate::AUTH_URL is empty or not set"
    exit 1
fi

if ! echo "${AUTH_URL}" | "${sf_command[@]}" > loginResult.json 2>&1; then
    echo "${red}${bold}Command failed with exit code $?${reset}"
    if [ -f loginResult.json ]; then
        cat loginResult.json
    fi
    echo "::error title=Failed to authenticate::Command execution failed"
    exit 1
fi

status=$(jq -r '.status // 0' loginResult.json 2>/dev/null || echo "1")

if [ "${status}" != "0" ]; then
    message=$(jq -r '.message // "Unknown error"' loginResult.json 2>/dev/null || echo "Failed to parse error message")
    echo "::error title=Failed to authenticate::${message}"
    exit 1
fi

echo "${green}${bold}Authenticate org successful.${reset}"
echo "${yellow}${bold}------------------------------------------------------------------------------------------${reset}"