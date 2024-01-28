#!/usr/bin/env bash

declare -A md5list
declare -A filelist

md5list=()
filelist=()
while read -r file; do
  dsum="$(md5sum "$file")"
  dsum="${dsum%% *}"
  filelist["$file"]="$dsum"
  md5list["$dsum"]+="*"
done < <(find . -type f -not -iname "*@eaDir*")


for i in "${!md5list[@]}"
do
  if [ "${md5list[$i]}" != "" ] && [ "${md5list[$i]}" != "*" ] ; then
    echo "key  : $i"
    echo "value: ${md5list[$i]}"
    for j  in "${!filelist[@]}"; do
      if [ "${filelist[$j]}" == "$i" ]; then
        if [ "$(file --brief --mime-type "$j")" != "text/plain" ]; then
          echo "guilty: $j"
        fi
      fi
    done
  fi
done
