#!/usr/bin/env bash

[[ "$TRACE" ]] && set -x
set -o pipefail

#curl jq emojify egrep
checkDep() {
  if ! type "egrep" &> /dev/null; then
   echo 'Missing command: egrep.... exiting'
   echo 'Maybe try: sudo apt-get install egrep'
   echo 'or'
   echo 'sudo yum install egrep'
   exit 1
  fi

  if ! type "curl" &> /dev/null; then
   echo 'Missing command: curl.... exiting'
   echo 'Maybe try: sudo apt-get install curl'
   echo 'or'
   echo 'sudo yum install curl'
   exit 1
  fi

  if ! type "jq" &> /dev/null; then
   echo 'Missing command: jq.... exiting'
   echo 'Maybe try: sudo apt-get install jq'
   echo 'or'
   echo 'sudo yum install jq'
   exit 1
  fi

  if ! type "emojify" &> /dev/null; then
   echo 'Missing command: jq.... exiting'
   echo 'trying to download the EMOJIFY script...'
   curl https://raw.githubusercontent.com/mrowa44/emojify/master/emojify -o emojify && chmod +x emojify
   echo 'Rerun this script to use it'
   exit 1
  fi
}

usage() {
  echo ' '
  echo ' ./start [time] [url]'
  echo '    * time: [Number], expressed in seconds (ex: 60 = 1min, 600 = 10min)'
  echo '    * url:  [URI], must be escaped !'
  echo '      >  https://webtask.it.auth0.com/api/run/(webtask_ID)/webtask\?webtask_no_cache\=1'
  echo ' '
  echo 'To run the script every 10 minutes :'
  echo '      > ./start.sh 600 https://webtask....'
}

main() {
  checkDep
  #TODO: if no param display usage
  : ${1:-60}
  while true; do
    curl --silent $2 | jq '.[]' | \
    sed 's/\&amp;/\&/g' | \
    GREP_COLORS='mt=01;32' grep --color=always -E '@\S+|' | \
    GREP_COLORS='mt=01;35' grep --color=always -E '#\S+|' | \
    GREP_COLORS='mt=01;33' grep --color=always -E 'http(s){0,1}:\/\/?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\S+|' | \
    GREP_COLORS='mt=01;31' grep --color=always -E 'http(s){0,1}:\/\/?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\S+\.(jpg|png|jpeg)|' | \
    GREP_COLORS='mt=01;36' grep --color=always -E 'https:\/\/twitter.com\/?\S+|' | \
    GREP_COLORS='mt=01;37' grep --color=always -E 'https:\/\/github.com\/?\S+|' | \
    emojify;
    sleep $1;
  done


}

main $@
