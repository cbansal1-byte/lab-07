#!/bin/bash

for dir in Testcase1 Testcase2 Testcase3 Testcase4; do
  out="${dir}Diff"

  rm -rf "$out"

  for f1 in "$dir"/*.1.txt; do
    f2="${f1%.1.txt}.2.txt"
    name=$(basename "$f1" .1.txt)

    if ! cmp -s "$f1" "$f2"; then
      mkdir -p "$out"
      diff -u "$f1" "$f2" > "$out/${name}Diff.txt"
    fi
  done
done