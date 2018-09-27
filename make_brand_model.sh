#!/bin/bash

# Parse each line of the input file, expand them into multiple lines with 9
# different colors. E.g.,
#
# ./make_brand_model.sh brand_model.txt > brand_model_color.txt
#
# brand_model.txt:
#
# 'Acura' 'CL'
# 'Acura' 'Integra'
#
# brand_model_color.txt:
#
# 'Acura' 'CL' 'white'
# 'Acura' 'CL' 'black'
# ...
# 'Acura' 'Integra' 'white'
# ...
#
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
colors=(white black silver gray red blue beige yellow green)
cat "$input_file" | while read line; do
    for color in ${colors[@]}; do
        echo $line \'$color\'
    done
done
