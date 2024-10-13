#!/bin/sh
echo -ne '\033c\033]0;SimpleGame\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/simplegameV1.x86_64" "$@"
