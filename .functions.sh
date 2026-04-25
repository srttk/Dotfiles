#!/bin/bash

# Function to create a directory and enter it
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Check my dotfiles loaded
function mydotfiles() {
    echo "My Dotfiles works!"
    echo "$(pwd)"
}


# Sequential Downloader Function
dlx() {
    # Check if input file is provided
    if [[ -z "$1" ]]; then
        echo "Usage: dlx <links-file>"
        return 1
    fi

    local i=1
    # Read the file line by line
    while read -r line || [[ -n "$line" ]]; do
        # Skip empty lines or lines starting with #
        [[ -z "$line" || "$line" == \#* ]] && continue

        # Extract extension (removes query strings and finds last dot)
        local clean_url="${line%%\?*}"
        local ext="${clean_url##*.}"
        
        # If no extension found, default to 'dat' or leave blank
        [[ "$ext" == "$clean_url" ]] && ext="bin"

        local filename=$(printf "%04d.%s" $i "$ext")

        echo "[$i] Downloading to $filename..."
        wget -q -O "$filename" "$line"
        
        ((i++))
    done < "$1"
    
    echo "Successfully downloaded $((i-1)) files."
}
