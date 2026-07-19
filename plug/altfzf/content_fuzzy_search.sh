#!/bin/bash

MODE=$1
TARGET_DIR=$2

# If micro returned a valid folder, we move there before starting the fuzzy search
if [ ! -z "$TARGET_DIR" ] && [ -d "$TARGET_DIR" ]; then
    cd "$TARGET_DIR"
fi

if [ "$MODE" == "w" ]; then
    RES=$(rg --column --line-number --no-heading --color=always --smart-case --fixed-strings "" 2>/dev/null | \
    fzf --layout=reverse --ansi --disabled --delimiter ':' \
        --bind "change:reload(rg --column --line-number --no-heading --color=always --smart-case --fixed-strings {q} || true)" \
        --preview "bat --color=always --style=numbers --highlight-line {2} {1} 2>/dev/null || cat {1}")
elif [ "$MODE" == "r" ]; then
    RES=$(rg --column --line-number --no-heading --color=always --smart-case "" 2>/dev/null | \
    fzf --layout=reverse --ansi --disabled --delimiter ':' \
        --bind "change:reload(rg --column --line-number --no-heading --color=always --smart-case {q} || true)" \
        --preview "bat --color=always --style=numbers --highlight-line {2} {1} 2>/dev/null || cat {1}")
else
    echo "Error: Invalid search mode! Use either 'w' for word or 'r' for regex."
    exit 1
fi

if [ ! -z "$RES" ]; then
    # Keep the absolute path before the seatch result file name
    echo "$(pwd)/$RES" > /tmp/micro_fzf_result
else
    rm -f /tmp/micro_fzf_result
fi

