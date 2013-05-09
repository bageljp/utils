#!/bin/bash -x
#
# Usage: imap_ticket_regster.bash PJCODE imap-account@gmail.com password
#
#   $1 is ProjectCode. (require)
#   $2 is IMAP mail account. (require)
#   $3 is IMAP mail password. (require)
#   $4 is redmine:email:recieve_imap options.
#   $5 is rvm use ruby.
#----------------------------------------------------

if [ $# -lt 3 ]; then
    exit 1
fi

PJCODE="${1}"
MAIL_ACCOUNT="${2}"
PASSWORD="${3}"
EXTEND_OPTION="${4}"
RUBY_RVM="${5:-ruby-1.9.3-p327}"

export PATH="/usr/local/rvm/bin:${PATH}"
source /usr/local/rvm/scripts/rvm
rvm use ${RUBY_RVM}
cd /usr/local/redmine/${PJCODE}
bundle exec bundle exec rake -f /usr/local/redmine/${PJCODE}/Rakefile \
redmine:email:receive_imap \
RAILS_ENV="production" \
host=imap.gmail.com \
port=993 \
ssl=1 \
username=${MAIL_ACCOUNT} \
password=${PASSWORD} \
${EXTEND_OPTION}

exit 0

#====================================================
# Mail format sample.
#   http://redmine.jp/faq/issue/mail-handler-keywords/
#====================================================
# [To]
#----------------------------------------------------
# IMAP mail account. (imap-account@gmail.com)
#====================================================
# [Subject]
#----------------------------------------------------
# Ticket title.
#====================================================
# [Body]
#----------------------------------------------------
# project: <プロジェクト識別子>
# tracker: <トラッカー名>
# assigned to: <担当者アドレス>
# due date: 2013-05-09（期限）
# <custom field>: <value>
#
# メールによるチケット登録のテスト（チケット本文）
#----------------------------------------------------
#====================================================
