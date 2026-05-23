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


# rvs -  reverses the base name (excluding extension) of a given file and renames it accordingly.

rvs() {
    local file="$1"
    
    # Check if argument is provided and file exists
    if [[ -z "$file" ]]; then
        echo "Error: No filename provided." >&2
        return 1
    fi
    if [[ ! -e "$file" ]]; then
        echo "Error: File '$file' does not exist." >&2
        return 1
    fi
    
    # Extract directory, basename, and extension
    local dir=$(dirname "$file")
    local basename=$(basename "$file")
    local name="${basename%.*}"          # part before last dot
    local ext="${basename##*.}"          # part after last dot
    
    # If there is no extension (basename == name), set ext to empty
    if [[ "$basename" == "$name" ]]; then
        ext=""
    else
        ext=".$ext"
    fi
    
    # Reverse the name part using 'rev'
    local reversed_name=$(echo -n "$name" | rev)
    
    # Construct new filename
    local new_basename="${reversed_name}${ext}"
    local new_file="${dir}/${new_basename}"
    
    # Rename (use -i to avoid accidental overwrites)
    mv -i "$file" "$new_file"
    
    # Optional: print result
    echo "Renamed: '$file' -> '$new_file'"
}

