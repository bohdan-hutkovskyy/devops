#!/usr/bin/env bash
set -e 

PANTS_SERVICES="src/python/pants/services"

declare -a APP_ARRAY
#git diff --name-only origin/master | sort -u | awk 'BEGIN {FS="src/python/pants/services"} {print $2}'

#git diff --name-only origin/master | xargs
diff_files=`git diff --name-only origin/master | xargs`
for x in ${diff_files}
do
    #echo "${x}" | awk 'BEGIN {FS="src/python/pants/services"} {print $2}' | cut -d'/' -f3
    APP=`echo "${x}" | awk 'BEGIN {FS="src/python/pants/services"} {print $2}' | cut -d'/' -f3` 
    if [ -n "$APP" ]; then
      #echo $APP
      APP_ARRAY+=($APP)
    fi

done

# echo $APP
#echo $APP_ARRAY
# echo ${!APP_ARRAY[@]}

echo ${APP_ARRAY[@]}

#Remove Duplicates
APP_ARRAY=($(printf '%s\n' "${APP_ARRAY[@]}" | sort -u))
echo ${APP_ARRAY[@]}

# array=("item 1" "item 2" "item 3")
# for i in "${array[@]}"; do   # The quotes are necessary here
#     echo "$i"
# done