#!/bin/bash

# Iterates through all the directories under <base_dir> and the images, creates
# a list of mkdir commands to create unique brand names under <output_dir>, and
# then creates a list of mv commands to move all the images under <base_dir> to
# their corresponding brand dir under <output_dir>. E.g., for
#
# <base_dir>/'Acura' 'CL'/1.jpg
# <base_dir>/'Acura' 'CL'/2.jpg
# <base_dir>/'Acura' 'Integra'/1.jpg
#
# this script outputs
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

# Print a list of mkdir commands for each unique brand in $base_dir, created
# under $output_dir.
brands_txt=""
for dir in "$base_dir"/*; do
    dir_name=$(basename "$dir")
    brand="$(echo "$dir_name" | sed "s/^'\([^']*\)'.*/\1/")"
    brands_text+="$brand\n"
done

printf "$brands_text" | sort | uniq | while read brand; do
    printf "mkdir -p \"%s/%s\"\n" "$output_dir" "$brand"
done

# Print a list of mv commands to move all photos into their corresponding
# brand dir under $output_dir.
for dir in "$base_dir"/*; do
    dir_name=$(basename "$dir")
    brand="$(echo "$dir_name" | sed "s/^'\([^']*\)'.*/\1/")"
    for img in "$dir"/*; do
        printf "mv \"%s\" \"%s/%s/\"\n" "$img" "$output_dir" "$brand"
    done
done
