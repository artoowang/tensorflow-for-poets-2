#!/bin/bash

# For some reason tensorflow seems to have issue with a filename too long? Not
# sure what is the limit, value chosen by try-and-error.
MAX_FILENAME_LENGTH=200

do_remove="no"

# options may be followed by one colon to indicate they have a required
# argument. Notice that using -o seems obligated
if ! options=$(getopt -o r -l do_remove -- "$@")
then
    # something went wrong, getopt will put out an error message for us
    exit 1
fi

# "eval" is necessary to handle arguments with space in them.
eval set -- "$options"

while [ $# -gt 0 ]
do
    case $1 in
    -r|--do_remove) do_remove="yes" ;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*) break;;
    esac
    shift
done

if [ $# -lt 1 ]; then
    echo "Usage: $0 <photo_root>"
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
        filename=$(basename "$file")
        to_remove="no"
        if [ ${#filename} -gt $MAX_FILENAME_LENGTH ]; then
            echo "File name too long: $file"
            to_remove="yes"
        fi
        if ! identify "$file" >/dev/null 2>/dev/null; then
            echo "Invalid image: $file"
            to_remove="yes"
        fi
        if [ "$to_remove" = "yes" -a "$do_remove" = "yes" ]; then
            rm -f "$file"
        fi
    done
done
