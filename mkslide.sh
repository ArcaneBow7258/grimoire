#!/usr/bin/bash
name=$(basename "$1")
out=$(echo "$1" | sed -e "s/content\//public\//g") 
out=$(echo "$out" | sed -e "s/$name/slides.html/g")
# echo $out
# echo $1
npx @marp-team/marp-cli@latest "$1" -o "$out"