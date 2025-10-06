#!/bin/bash

ordinal() {
  d=$1
  # 11-13 are special
  if [ $((d % 100)) -ge 11 ] && [ $((d % 100)) -le 13 ]; then
    echo "th"; return
  fi
  case $((d % 10)) in
    1) echo "st" ;;
    2) echo "nd" ;;
    3) echo "rd" ;;
    *) echo "th" ;;
  esac
}

DAY=$(date '+%a')
DAY_NUM=$(date '+%-d')
SUF=$(ordinal "$DAY_NUM")
DATE_STR="$DAY ${DAY_NUM}${SUF}"

TIME=$(date '+%H:%M')

sketchybar --set "$NAME" icon="$DATE_STR" label="$TIME"
