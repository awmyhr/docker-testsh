#!/bin/sh
#==============================================================================
#:"""
#: .. program:: usr-local-bin-login.sh
#:    :synopsis: Create a new user and login as that user.
#:
#:    :copyright: 2018 awmyhr
#:    :license: Apache-2.0
#:
#: .. codeauthor:: awmyhr <awmyhr@gmail.com>
#:
#: Intended as an entrypoint to interactive, CLI-based Docker containers,
#: this script will create a user, grant the user sudo access, then su to
#: that user.
#:"""
#==============================================================================
#-- Variables which are meta for the script should be dunders (__varname__)
__version__='1.0.0-beta5' #: current version
__revised__='20180727-105116' #: date of most recent revision
__contact__='awmyhr <awmyhr@gmail.com>' #: primary contact for support/?'s
__synopsis__='Create a new user and login as that user.'
__description__="
Intended as an entrypoint to interactive, CLI-based Docker containers,
this script will create a user, grant the user sudo access, then su to
that user.
"
#------------------------------------------------------------------------------
#-- The following few variables should be relatively static over life of script
__author__='awmyhr <awmyhr@gmail.com>' #: coder(s) of script
__created__='2018-07-27'               #: date script originlly created
__copyright__='2018 awmyhr' #: Copyright short name
__license__='Apache-2.0'
__cononical_name__='usr-local-bin-login.sh' #: static name, *NOT* os.path.basename(sys.argv[0])
__project_name__='SysAdmin Shell'  #: name of overall project, if needed
__project_home__='https://github.com/awmyhr/docker-sash'  #: where to find source/documentation
__template_version__='1.0.0'             #: version of template file used
#-- We are not using this variable for now.
# shellcheck disable=2034
__docformat__='reStructuredText en'      #: attempted style for documentation
__basename__="${0}" #: name script run as
#==============================================================================
#-- Print help if requested.
if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
    printf '(%s)\n' "${__basename__}"
    printf '%s\n' "${__synopsis__}"
    printf '%s\n' "${__description__}"
    printf 'The following environment variables are used:\n'
    printf 'ADD_UNAME - user name to create (defaults to default)\n'
    printf 'ADD_GNAME - group name to create (defaults to ADD_UNAME)\n'
    printf 'ADD_UID   - UID to assign\n'
    printf 'ADD_GID   - GID to assing\n'
    printf 'ADD_HOME  - home directory path\n'
    printf 'ADD_SHELL - login shell for user\n'
    printf 'Unless otherwise specified, unset values will drop to sytem defaults.\n'
    printf '\n'
    printf 'Created: %s  Contact: %s\n' "${__created__}" "${__contact__}"
    printf 'Revised: %s  Version: %s\n' "${__revised__}" "${__version__}"
    printf '%s, part of %s.\n' "${__cononical_name__}" "${__project_name__}"
    printf 'Project home: %s\n' "${__project_home__}"
    printf '(c) Copyright %s (License: %s)\n' "${__copyright__}" "${__license__}"
    printf 'By %s; based on template version %s.\n' "${__author__}" "${__template_version__}"
    exit 0
fi
#==============================================================================
#-- Check/set paramaters.
if [ "z${ADD_UNAME}" = 'z' ] ; then ADD_UNAME='default'           ; fi
if [ "z${ADD_GNAME}" = 'z' ] ; then ADD_GNAME="${ADD_UNAME}"      ; fi
if [ "z${ADD_UID}" = 'z' ]   ; then ADD_UID=''; else ADD_UID="-u ${ADD_UID}"; fi
if [ "z${ADD_GID}" = 'z' ]   ; then ADD_GID=''; else ADD_GID="-g ${ADD_GID}"; fi
if [ "z${ADD_SHELL}" = 'z' ] ; then ADD_SHELL=''
elif [ ! -x "${ADD_SHELL}" ] ; then ADD_SHELL=''
else ADD_SHELL="--shell ${ADD_SHELL}"
fi
if [ "z${ADD_HOME}" = 'z' ]  ; then ADD_HOME='-m'
elif [ ! -d "${ADD_HOME}" ]  ; then
    mkdir -p "$(dirname ${ADD_HOME})"
    ADD_HOME="-m -d ${ADD_HOME}"
else ADD_HOME="-M -d ${ADD_HOME}"
fi

#==============================================================================
#-- Create objects and change user.
#   NOTE: Do *not* quote any vars aside from ADD_UNAME and ADD_GNAME
groupadd ${ADD_GID} "${ADD_GNAME}"
if [ "z${ADD_GID}" = 'z' ]   ; then ADD_GID="-g ${ADD_GNAME}"; fi
useradd -l ${ADD_UID} ${ADD_GID} ${ADD_HOME} ${ADD_SHELL} "${ADD_UNAME}"
echo "${ADD_UNAME}  ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

exec su --login "${ADD_UNAME}"
