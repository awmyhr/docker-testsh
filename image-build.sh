#!/bin/sh
#--
# Revised:    20180807-100346
#--
FLAVOR="${1:-centos}"
PREFIX="${2:-testsh-}"
INAME="${PREFIX}${FLAVOR}"
#--
if [ -f "Dockerfile.${FLAVOR}" ] ; then
    ln -fs "Dockerfile.${FLAVOR}" Dockerfile
else
    >&2 printf 'ERROR: %s does not exist.\n' "Dockerfile.${FLAVOR}"
    exit 69
fi
#--
if [ "z$(docker images -q "${INAME}" 2>/dev/null)" = 'z' ] ; then
    docker build -t "${INAME}" .
else
    >&2 printf 'ERROR: %s exists, please remove it first.\n' "${INAME}"
    exit 78
fi
