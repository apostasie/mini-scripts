#!/usr/bin/env bash

# Bash 5 only
declare -A md5list
declare -A filelist

far::dedup(){
  md5list=()
  filelist=()
  while read -r file; do
    dsum="$(md5sum "$file")"
    dsum="${dsum%% *}"
    filelist["$file"]="$dsum"
    md5list["$dsum"]+="*"
  done < <(find "$1" -type f)

  for i in "${!md5list[@]}"
  do
    if [ "${md5list[$i]}" != "" ] && [ "${md5list[$i]}" != "*" ] ; then
      echo "Duplicate:"
      echo "- key  : $i"
      echo "- value: ${md5list[$i]}"
      for j  in "${!filelist[@]}"; do
        if [ "${filelist[$j]}" == "$i" ]; then
          if [ "$(file --brief --mime-type "$j")" != "text/plain" ]; then
            echo "Duplicate entries: $j"
          fi
        fi
      done
    fi
  done
}

far::dedup "${1:-$(pwd)}"