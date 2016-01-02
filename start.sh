#!/usr/bin/env bash

[[ "$TRACE" ]] && set -x
set -o pipefail

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)
purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

#curl jq emojify egrep
checkDep() {
  if ! type "egrep" &> /dev/null; then
   echo 'Missing command: egrep.... exiting'
   echo 'Check your \$PATH or try to install it'
   echo '${bold}sudo apt-get install grep{reset}'
   echo 'For Debian or for CentOS:'
   echo '${bold}sudo yum install grep{reset}'
   exit
  fi

  if ! type "curl" &> /dev/null; then
   echo 'Missing command: curl.... exiting'
   echo 'Check your \$PATH or try to install it'
   echo '${bold}sudo apt-get install curl${reset}'
   echo 'For Debian or for CentOS:'
   echo '${bold}sudo yum install curl${reset}'
   exit
  fi

  if ! type "jq" &> /dev/null; then
   echo 'Missing command: jq.... exiting'
   echo 'The script can be found at ${underline}${bold}https://stedolan.github.io/jq/download/${reset}'
   echo '${bold}${blue}===> trying to download jq for you...${reset}'
   echo 'curl https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o jq && chmod +x jq'
   curl https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o jq && chmod +x jq
   echo 'Rerun this script to use it'
   exit
  fi

  if ! type "emojify" &> /dev/null; then
   echo 'Missing command: emojify.... exiting'
   echo 'The script can be found at ${underline}${bold}https://raw.githubusercontent.com/mrowa44/emojify/master/emojify${reset}'
   echo '===> trying to download the EMOJIFY script for you...'
   echo 'curl https://raw.githubusercontent.com/mrowa44/emojify/master/emojify -o emojify && chmod +x emojify'
   curl https://raw.githubusercontent.com/mrowa44/emojify/master/emojify -o emojify && chmod +x emojify
   echo 'Rerun this script to use it'
   exit
  fi
}

usage() {
cat<<EOF

     ./start.sh [url] [time]
        * ${bold}${blue}url${reset}:  [URI], must be escaped,
            This url can be found when installing your script as a webtask.
            To install your webtask: see #(github_readme_url)
            ex: ${tan}https://webtask.it.auth0.com/api/run/(webtask_ID)/webtask${red}\?webtask_no_cache\=1${reset}
        * ${bold}${blue}time${reset}: [Number], optional, expressed in seconds ( default to 600 = 10min)


    To run the script every 10 minutes :
          ${bold}> ./start.sh ${underline}https://webtask....${reset}
    To run the script every hours :
          ${bold}> ./start.sh ${underline}https://webtask.... ${red}3600 ${reset}
EOF

}

main() {
  checkDep
  #TODO: create --url and --interval param ?
  if [[ $# -eq 0 ]]; then
    echo
    echo 'No webtask URL... exiting'
    usage
  fi

  if [[ $1 =~ "http(s){0,1}:\/\/?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\S+" ]]; then
    echo
    echo "Link valid"
  else
    echo
    echo "Not a url"
    usage
  fi

  while true; do
    curl --silent $1 | jq '.[]' | \
    sed 's/\&amp;/\&/g' | \
    GREP_COLORS='mt=01;32' grep --color=always -E '@\S+|' | \
    GREP_COLORS='mt=01;35' grep --color=always -E '#\S+|' | \
    GREP_COLORS='mt=01;33' grep --color=always -E 'http(s){0,1}:\/\/?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\S+|' | \
    GREP_COLORS='mt=01;31' grep --color=always -E 'http(s){0,1}:\/\/?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\S+\.(jpg|png|jpeg)|' | \
    GREP_COLORS='mt=01;36' grep --color=always -E 'https:\/\/twitter.com\/?\S+|' | \
    GREP_COLORS='mt=01;37' grep --color=always -E 'https:\/\/github.com\/?\S+|' | \
    emojify;
    sleep ${2:-600};
  done
}

main $@
