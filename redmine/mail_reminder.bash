#!/bin/bash -x
#
# Usage: mail_reminder.bash PJCODE 7
#
#   $1 is ProjectCode. (require)
#   $2 is limit days.
#   $3 is user id.
#   $4 is rvm use ruby.
#----------------------------------------------------

if [ $# -lt 1 ]; then
    exit 1
fi

PJCODE="${1}"
DAYS="${2:-0}"
USER="${3:-0}"
RUBY_RVM="${4:-ruby-1.9.3-p327}"

export PATH="/usr/local/rvm/bin:${PATH}"
source /usr/local/rvm/scripts/rvm
rvm use ${RUBY_RVM}
cd /usr/local/redmine/${PJCODE}

if [ "${USER}" -eq "0" ]; then
    bundle exec rake redmine:send_reminders days=${DAYS} RAILS_ENV=production
else
    bundle exec rake redmine:send_reminders days=${DAYS} users=${USER} RAILS_ENV=production
fi

exit 0

