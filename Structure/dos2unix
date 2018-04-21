#!/bin/bash
# dos2unix utility using translate characters command
# requires /usr/bin/tr

for f in "$@"
do
  if [ -f "$f" ]; then
    echo "dos2unix $f"
    cat $f | /usr/bin/tr -d "\015" > "$f.tmp"
    mv  "$f.tmp"  "$f"
  fi
done
