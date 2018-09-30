#!/bin/bash

run="no"

# options may be followed by one colon to indicate they have a required
# argument. Notice that using -o seems obligated
if ! options=$(getopt -o r -l run -- "$@")
then
    # something went wrong, getopt will put out an error message for us
    exit 1
fi

# "eval" is necessary to handle arguments with space in them.
eval set -- "$options"

while [ $# -gt 0 ]
do
    case $1 in
    -r|--run) run="yes" ;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

if [ $# -lt 1 ]; then
    echo "Usage: $0 [-r|--run] <photo_root>"
    exit 1
fi

PHOTO_ROOT="$1"

for label in "$PHOTO_ROOT"/*; do
    if [ ! -d "$label" ]; then
        echo "Not a directory: $label"
        continue
    fi
    echo "Processing directory \"$label\" ..."
    for file in "$label"/*; do
        echo convert "$file" "$file"
        if [ "$run" = "yes" ]; then
            convert "$file" "$file"
        fi
    done
done
