#!/bin/sh
# Wrapper around msgmerge that removes the volatile POT-Creation-Date
# line from the output .po file.
set -e

outfile=""
prev=""
for arg in "$@"; do
    case "$arg" in
        --output-file=*)
            outfile="${arg#--output-file=}"
            ;;
    esac
    if [ "$prev" = "-o" ]; then
        outfile="$arg"
        break
    fi
    prev="$arg"
done

real_msgmerge=""
for dir in $(echo "$PATH" | tr ":" " "); do
    if [ -x "$dir/msgmerge" ] && [ "$dir/msgmerge" != "$0" ]; then
        if [ "$(readlink -f "$dir/msgmerge")" != "$(readlink -f "$0")" ]; then
            real_msgmerge="$dir/msgmerge"
            break
        fi
    fi
done

if [ -z "$real_msgmerge" ]; then
    echo "msgmerge-wrapper: real msgmerge not found in PATH" >&2
    exit 1
fi

"$real_msgmerge" "$@"

if [ -n "$outfile" ] && [ -f "$outfile" ]; then
    sed -i "/^\"POT-Creation-Date:/d" "$outfile"
fi
