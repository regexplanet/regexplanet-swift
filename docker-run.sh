#!/usr/bin/env bash
#
# run it in Docker
#

set -o errexit
set -o pipefail
set -o nounset

ENVFILE=".env"

if [ -f "${ENVFILE}" ]
then
	export $(cat "${ENVFILE}")
fi


DOCKER_BUILDKIT=1 docker build -t regexplanet-swift .

docker run -it \
    -p 8080:8080 \
    -e LOG_LEVEL=${LOG_LEVEL:-trace} \
    -e PORT=8080 \
    regexplanet-swift
