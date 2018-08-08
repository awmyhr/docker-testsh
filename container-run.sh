#!/bin/sh
#--
# Revised:    20180807-102506
#--
FLAVOR="${1:-centos}"
PREFIX="${2:-testsh-}"
UNAME="$(id -un)"
CNAME="${PREFIX}${UNAME}"
#--
if [ "z$(docker ps -q -f "name=${CNAME}" 2>/dev/null)" = 'z' ] ; then
    >&2 printf 'ERROR: %s does not exist, please create it first.\n' "${CNAME}"
    exit 78
fi
#--
docker exec --tty --interactive "${CNAME}" su - "${UNAME}"
