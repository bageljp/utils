#!/bin/bash
#------------------------------------------------------------------------------
#
# Author(s): K.Kadoyama
#
# Usage:
#   log_del.bash {log_dir} {log_file(regex)} [days]
#
# Current Version: 1.0.0
#
# Revision History:
#
#   Version 1.0.0 by K.Kadoyama (2011/11/24)
#     - Initial new.
#
# Example:
#
#   # crontab -l
#   0 5 * * *   /path/to/log_del.bash /var/log/httpd access_log* 93
#
#------------------------------------------------------------------------------
#==============================================================================
# Define
#==============================================================================
DIR_LOG="${1}"
FL_LOG="${2:-*.log}"
DEL_DAYS="${3:-31}"
DIR_TMP="/tmp"
LOG_TMP="${DIR_TMP}/`basename $0 .bash`_`basename ${DIR_LOG}`_${DEL_DAYS}.log"
FL_TMP="log_del.tmp"
CMD_FIND="/bin/find"
CMD_XARGS="/usr/bin/xargs"

#==============================================================================
# Main
#==============================================================================
if [ $# -lt 3 ]; then
    echo "Usage: log_del.bash {log_dir} {log_file(regex)} [days]"
    exit 1
fi
if [ ! -d ${DIR_TMP} ]; then
    mkdir -p ${DIR_TMP}
fi
cd ${DIR_LOG} || exit 1
touch ${FL_TMP}
${CMD_FIND} "${DIR_LOG:-/notdefine}" \( -name "${FL_LOG}" -type f -mtime +${DEL_DAYS} -o -name "${FL_TMP}" \) -print0 | ${CMD_XARGS} -0 ls -l > ${LOG_TMP}
${CMD_FIND} "${DIR_LOG:-/notdefine}" \( -name "${FL_LOG}" -type f -mtime +${DEL_DAYS} -o -name "${FL_TMP}" \) -print0 | ${CMD_XARGS} -0 rm -f

exit 0
