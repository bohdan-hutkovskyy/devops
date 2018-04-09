#!/bin/bash

# disabling set -e and relying on explicitly defined exit codes due to expected
# failures as negative tests
#set -e

bom_sniffer() { 
  # exit code is 1 if character not found
  head -c3 "$1" | LC_ALL=C grep -qP '\xef\xbb\xbf'; 
  if [ $? -eq 0 ] 
  then 
    echo "BOM SNIFFER DETECTED BOM CHARACTER IN FILE \"$1\""
    exit 1
  fi
}
check_rc() {
  # exit if passed in value is not = 0
  # $1 = return code
  # $2 = command / label
  if [ $1 -ne 0 ]
  then
    echo "$2 command failed"
    exit 1
  fi
}

# finding files that differ from this commit and master
echo 'git fetch'
check_rc $? 'echo git fetch'
git fetch
check_rc $? 'git fetch'
echo 'git diff --name-only origin/master'
check_rc $? 'echo git diff'
diff_files=`git diff --name-only origin/master | xargs`
check_rc $? 'git diff'
for x in ${diff_files}
do
  #echo "${x}"
  bom_sniffer "${x}"
  check_rc $? "BOM character detected in ${x},"
done
