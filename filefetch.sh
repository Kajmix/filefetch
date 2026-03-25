#!/bin/bash
path="$1"
FILENAME="${path##*/}"
BASENAME="${FILENAME%.*}"
#ASCII:
ASCII=(
    "@@@@@@@@@@@@"
    "@@        @@"
    "@@    @@  @@"
    "@@  @@@@  @@"
    "@@        @@"
    "@@  @@@@  @@"
    "@@        @@"
    "@@@@@@@@@@@@"
)

# Colors:
GREEN="\033[32m"
RESET="\033[0m"

#All stored data:
INFO=()

function get_name {
    if [ -f "$path" ]; then
        INFO+=("${GREEN}| File name:${RESET} ${BASENAME}")
    elif [ -d "$path" ]; then
        tmp="${path%/*}"
        tmp="${tmp%/*}"
        result="${tmp##*/}"
        INFO+=("${GREEN}| Directory name:${RESET} ${result}")
    fi
}

#Get photo resolution:
function get_pixels {
    resolution=$(file "${path}" | grep -o "[0-9]\+[[:space:]]*x[[:space:]]*[0-9]\+")
    INFO+=("${GREEN}| Resolution: ${RESET}${resolution}")
}

#Get file size:
function get_size {
    if [ -f "$path" ]; then
        FILESIZE=$(stat -c%s "$path" | numfmt --to=iec --suffix=B)
        INFO+=("${GREEN}| File size:${RESET} ${FILESIZE}")
    elif [ -d "$path" ]; then
        DIRECTORY_SIZE=$(du -sb "$path" 2>/dev/null | cut -f1)
        DIRECTORY_SIZE=$(numfmt --to=iec --suffix=B "$DIRECTORY_SIZE")
        INFO+=("${GREEN}| Directory size:${RESET} ${DIRECTORY_SIZE}")
    fi
}

function get_file_path {
    INFO+=("${GREEN}| Full file path:${RESET} $(pwd)/${path}")
}

function get_extenction {
    EXTENCTIONS="${path##*.}"
    INFO+=("${GREEN}| File type:${RESET} ${EXTENCTIONS}")
}

function get_creation_date {
    INFO+=("${GREEN}| Creation date:${RESET} $(date -d "$(stat -c %w "$path")" "+%Y-%m-%d %H:%M:%S")")
}

function get_last_modification_date {
    INFO+=("${GREEN}| Last modification date:${RESET} $(date -d "$(stat -c %y "$path")" "+%Y-%m-%d %H:%M:%S")")
}

function gap {
    INFO+=("${GREEN}|-------------------------------------${RESET}")
}

function get_all_files {
    INFO+=("${GREEN}| Number of all files in directory:${RESET} $(find "$path" -type f | wc -l)")
}
# Section for files:
if [ -f "$path" ]; then
    clear
    get_name
    gap
    get_file_path
    get_size
    #checks if file has extenction
    if [[ "$path" == *.* ]]; then
        get_extenction
    fi
    # INFO+=("${GREEN}| Author:${RESET} $(stat -c %U "$path")")
    get_creation_date
    get_last_modification_date
    if [[ "$EXTENCTIONS" == "png" || "$EXTENCTIONS" == "jpg" || "$EXTENCTIONS" == "raw" || "$EXTENCTIONS" == "webp" ]]; then
        get_pixels
    fi
elif [ -d "$path" ]; then
    clear
    get_name
    gap
    get_file_path
    get_size
    get_creation_date
    get_last_modification_date
    get_all_files
else
    INFO=()
    INFO+=("File not found")
fi
#Print all data:
max=${#ASCII[@]}
if [ ${#INFO[@]} -gt $max ]; then
    max=${#INFO[@]}
fi

for ((i=0; i<max; i++)); do
    ascii="${ASCII[$i]}"
    info="${INFO[$i]}"
    echo -e "${GREEN}${ascii:-}""$RESET  ${info:-}"
done
echo