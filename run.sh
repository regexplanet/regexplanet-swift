#!/bin/bash
#
# run locally for dev
#

set -o errexit
set -o pipefail
set -o nounset

clear

#
# load an .env file if it exists
#
ENV_FILE="${1:-./.env}"
if [ -f "${ENV_FILE}" ]; then
    echo "INFO: loading '${ENV_FILE}'!"
    export $(cat "${ENV_FILE}")
fi

swift run
