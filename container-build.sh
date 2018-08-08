#!/bin/sh
#--
# Revised:    20180807-102506
#--
FLAVOR="${1:-centos}"
PREFIX="${2:-testsh-}"
UNAME="$(id -un)"
CNAME="${PREFIX}${UNAME}"
INAME="${PREFIX}${FLAVOR}"
#--
if [ "z$(docker images -q "${INAME}" 2>/dev/null)" = 'z' ] ; then
    >&2 printf 'ERROR: %s does not exist, please create it first.\n' "${INAME}"
    exit 69
fi
if [ "z$(docker ps -q -f "name=${CNAME}" 2>/dev/null)" != 'z' ] ; then
    >&2 printf 'ERROR: %s exists, please remove it first.\n' "${CNAME}"
    exit 78
fi
#--
docker run --tty --detach \
    --env ADD_UNAME="${UNAME}" \
    --env ADD_UID="$(id -u)" \
    --env ADD_GID="$(id -g)" \
    --env ADD_SHELL="${SHELL}" \
    --volume   "${HOME}:/home/${UNAME}:rw" \
    --hostname "$(hostname -s)-${CNAME}" \
    --name     "${CNAME}" \
    "${INAME}"
