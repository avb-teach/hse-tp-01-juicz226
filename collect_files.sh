#!/bin/bash
input="$1"
output="$2"
max_depth=""


if [[ "$1" == "--max_depth" ]]; then
    max_depth="$2"
    input="$3"
    output="$4"
    if ! [[ "$max_depth" =~ ^[0-9]+$ ]]; then
        echo "Error: --max_depth must be a number"
        exit 1
    fi
fi


if [[ ! -d "$input" ]]; then
    echo "Error: Input directory not found"
    exit 1
fi

mkdir -p "$output"


find_cmd="find \"$input\" -type f"
if [[ -n "$max_depth" ]]; then
    find_cmd+=" -maxdepth $max_depth"
fi

counter=1
while IFS= read -r file; do
    name=$(basename "$file")
    dest="$output/$name"
    
    
    while [[ -e "$dest" ]]; do
        base="${name%.*}"
        ext="${name##*.}"
        dest="$output/${base}_$((counter++)).${ext}"
    done
    
    cp "$file" "$dest"
done < <(eval "$find_cmd")