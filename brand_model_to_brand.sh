#!/bin/bash

# Iterates through all the directories under <base_dir> and the images, runs
# a list of mkdir commands to create unique brand names under <output_dir>, and
# then runs a list of mv commands to move all the images under <base_dir> to
# their corresponding brand dir under <output_dir>. E.g., for
#
# <base_dir>/'Acura' 'CL'/1.jpg
# <base_dir>/'Acura' 'CL'/2.jpg
# <base_dir>/'Acura' 'Integra'/1.jpg
#
# this script runs
#
# mkdir -p <output_dir>/Acura
# mv <base_dir>/'Acura' 'CL'/1.jpg <output_dir>/Acura/
# mv <base_dir>/'Acura' 'CL'/2.jpg <output_dir>/Acura/
# mv <base_dir>/'Acura' 'Integra'/1.jpg <output_dir>/Acura/
#
if [ $# -lt 2 ]; then
    echo "Usage: $0 <base_dir> <output_dir>"
    exit 1
fi

base_dir="$1"
output_dir="$2"

# Run mkdir commands.
brands_txt=""
for dir in "$base_dir"/*; do
    dir_name=$(basename "$dir")
    brand="$(echo "$dir_name" | sed "s/^'\([^']*\)'.*/\1/")"
    brands_text+="$brand\n"
done

printf "$brands_text" | sort | uniq | while read brand; do
    echo mkdir -p "$output_dir"/"$brand"
    mkdir -p "$output_dir"/"$brand"
done

# Run mv commands.
for dir in "$base_dir"/*; do
    dir_name=$(basename "$dir")
    brand="$(echo "$dir_name" | sed "s/^'\([^']*\)'.*/\1/")"
    for img in "$dir"/*; do
        echo mv "$img" "$output_dir"/"$brand"
        mv "$img" "$output_dir"/"$brand"
    done
done
