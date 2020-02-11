#!/bin/bash

set -e

RUN_LIMIT=1000
EDITORCONFIG_CONFIG_FILE=".editorconfig"
ROOT_TRUE_STATEMENT_REGEX="^[ \t]*root[ \t]*=[ \t]*true[ \t]*\$"

ALLMATCH=0
while getopts a opts; do
  case "$opts" in
    a)
      ALLMATCH=1
      ;;
    ?)
      echo "Usage: $0 [-a]" 1>&2
      echo "  -a: find all (ignore 'root=true')" 1>&2
      ;;
  esac
done

for i in $(seq 0 $RUN_LIMIT); do
  if [ -r "./$EDITORCONFIG_CONFIG_FILE" ]; then
    # found config file!
    echo "$(pwd)"

    # don't check 'root=true' if '-a' is specified
    if [ "$ALLMATCH" -eq 0 ]; then
      MATCHED_LINE_NUMBER="$(grep -E "$ROOT_TRUE_STATEMENT_REGEX" "$EDITORCONFIG_CONFIG_FILE" | wc -l)"
      if [ "$MATCHED_LINE_NUMBER" -gt 0 ]; then
        # this config file has 'root=true'!
        exit 0
      fi
    fi
  fi
  if [ ! -x .. ]; then
    # exit 1 if cannot access parent directory
    exit 1
  fi
  if [ "$(pwd)" = "/" ]; then
    # exit if this directory is root
    exit 0
  fi
  cd ..
done

exit 0

