#!/usr/bin/env bash

set -e

if [ $# -eq 0 ]
then
  echo "No post name provided."
  exit 1
fi

today=$(date -I)
name=$(echo $1 | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]')
file=$today-$name.md

touch ./_posts/$file

cat <<EOF > ./_posts/$file
---
title: $1
categories: []
tags: []
---
EOF
