#!/bin/bash

status=0

for dir in Testcase1 Testcase2 Testcase3 Testcase4; do
  out="${dir}Diff"
  ok=1
  anydiff=0

  for f1 in "$dir"/*.1.txt; do
    f2="${f1%.1.txt}.2.txt"
    name=$(basename "$f1" .1.txt)
    outfile="$out/${name}Diff.txt"

    if cmp -s "$f1" "$f2"; then
      if [ -f "$outfile" ]; then
        echo "unexpected $outfile" >&2
        ok=0
      fi
    else
      anydiff=1
      if [ ! -f "$outfile" ]; then
        echo "missing $outfile" >&2
        ok=0
      elif ! cmp -s <(diff -u "$f1" "$f2" | tail -n +3) <(tail -n +3 "$outfile"); then
        echo "wrong contents in $outfile" >&2
        ok=0
      fi
    fi
  done

  if [ "$anydiff" -eq 1 ] && [ ! -d "$out" ]; then
    echo "missing directory $out" >&2
    ok=0
  elif [ "$anydiff" -eq 0 ] && [ -d "$out" ]; then
    echo "$out should not exist" >&2
    ok=0
  fi

  if [ "$ok" -eq 1 ]; then
    echo "$dir: PASS"
  else
    echo "$dir: FAIL"
    status=1
  fi
done

exit $status