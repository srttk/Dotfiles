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
dlx () {
	local rename=false
	local file=""

	# Parse flags and arguments
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-n)
				rename=true
				shift
				;;
			*)
				if [[ -z "$file" ]]; then
					file="$1"
				else
					echo "Error: Unexpected argument '$1'"
					return 1
				fi
				shift
				;;
		esac
	done

	if [[ -z "$file" ]]; then
		echo "Usage: dlx [-n] <links-file>"
		return 1
	fi

	if [[ ! -f "$file" ]]; then
		echo "Error: File '$file' not found."
		return 1
	fi

	local i=1
	while read -r line || [[ -n "$line" ]]; do
		# Skip empty lines and comments
		[[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

		# Strip trailing carriage returns (\r) for cross-platform safety
		line="${line%$'\r'}"

		if [[ "$rename" == true ]]; then
			local clean_url="${line%%\?*}"
			local ext="${clean_url##*.}"
			[[ "$ext" == "$clean_url" || -z "$ext" ]] && ext="bin"
			local filename=$(printf "%04d.%s" $i "$ext")
			echo "[$i] Downloading to $filename..."
			wget -q -O -nc "$filename" "$line"
		else
			echo "[$i] Downloading $(basename "${line%%\?*}")..."
			wget -q -nv -nc --content-disposition "$line"
		fi

		((i++))
	done < "$file"

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

