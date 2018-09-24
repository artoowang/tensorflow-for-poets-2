#!/bin/bash

PHOTO_ROOT=tf_files/car_photos

do_remove="no"

# TODO: on 2018/09/23 the following seems not working on OSX. Not sure what is wrong.
## options may be followed by one colon to indicate they have a required argument
## Notice that using -o seems obligated
#if ! options=$(getopt -o r -l do_remove -- "$@")
#then
#    # something went wrong, getopt will put out an error message for us
#    exit 1
#fi
#
## “eval” is necessary to handle arguments with space in them.
#eval set -- “$options”
#
#while [ $# -gt 0 ]
#do
#    case $1 in
#    -r|--do_remove) do_remove="yes" ;;
#    (--) shift; break;;
#    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
#    (*) break;;
#    esac
#    shift
#done

if [ $1 = "-r" ]; then
    do_remove="yes"
fi

for label in "$PHOTO_ROOT"/*; do
    if [ ! -d "$label" ]; then
        echo "Not a directory: $label"
        continue
    fi
    echo "Processing directory \"$label\" ..."
    for file in "$label"/*; do
        if ! identify "$file" >/dev/null 2>/dev/null; then
            echo "Invalid image: $file"
            if [ $do_remove = "yes" ]; then
                rm -f "$file"
            fi
        fi
    done
done
