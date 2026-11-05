#!/usr/bin/env bash

set -euo pipefail

trap 'rm -f loginResult.json loginError.log' EXIT

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

sf_exit_code=0
if echo "${AUTH_URL}" | "${sf_command[@]}" > loginResult.json 2> loginError.log; then
    :
else
    sf_exit_code=$?
fi

if [ -s loginError.log ]; then
    cat loginError.log >&2
fi

if ! jq -e . loginResult.json >/dev/null 2>&1; then
    echo "::error title=Authentication failed::Salesforce CLI exited with status ${sf_exit_code} and returned invalid JSON"
    cat loginResult.json || true
    exit 1
fi

status="$(jq -r '.status // empty' loginResult.json)"
message="$(jq -r '.message // "Unknown authentication error"' loginResult.json)"

if [ "${sf_exit_code}" -ne 0 ] || [ "${status}" != "0" ] || [ -z "${status}" ]; then
    echo "::error title=Failed to authenticate::${message} (Salesforce CLI exit code ${sf_exit_code})"
    exit 1
fi

echo "${green}${bold}Authenticate org successful.${reset}"
echo "${yellow}${bold}------------------------------------------------------------------------------------------${reset}"
