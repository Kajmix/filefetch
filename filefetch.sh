#!/bin/bash
path="$1"
FILENAME="${path##*/}"
BASENAME="${FILENAME%.*}"
#ASCII:
FILE_ASCII=(
    "@@@@@@@@@@@@"
    "@@        @@"
    "@@    @@  @@"
    "@@  @@@@  @@"
    "@@        @@"
    "@@  @@@@  @@"
    "@@        @@"
    "@@@@@@@@@@@@"
)

PHOTO_ASCII=(
    "@@@@@@@@@@@@"
    "@@        @@"
    "@@   ()   @@"
    "@@  /||\  @@"
    "@@   /\   @@"
    "@@@@@@@@@@@@"
    "@@@@@@@@@@@@"
    "@@@@@@@@@@@@"
)

DIRECTORY_ASCII=(
    "@@@@@@@@@@      "
    "@        @@@@@@@"
    "@              @"
    "@   @@@@@@@@   @"
    "@   @      @   @"
    "@   @@@@@@@@   @"
    "@              @"
    "@@@@@@@@@@@@@@@@"
)

# Colors:
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
#Reset color:
RESET="\033[0m"

#Here u can set color:
MAINCOLOR="${GREEN}"

#All stored data:
INFO=()

function get_name {
    if [ -f "$path" ]; then
        INFO+=("${MAINCOLOR}| File name:${RESET} ${BASENAME}")
    elif [ -d "$path" ]; then
        tmp="${path%/*}"
        tmp="${tmp%/*}"
        result="${tmp##*/}"
        INFO+=("${MAINCOLOR}| Directory name:${RESET} ${result}")
    fi
}

#Get photo resolution:
function get_pixels {
    resolution=$(file "${path}" | grep -o "[0-9]\+[[:space:]]*x[[:space:]]*[0-9]\+")
    INFO+=("${MAINCOLOR}| Resolution: ${RESET}${resolution}")
}

#Get file size:
function get_size {
    if [ -f "$path" ]; then
        FILESIZE=$(stat -c%s "$path" | numfmt --to=iec --suffix=B)
        INFO+=("${MAINCOLOR}| File size:${RESET} ${FILESIZE}")
    elif [ -d "$path" ]; then
        DIRECTORY_SIZE=$(du -sb "$path" 2>/dev/null | cut -f1)
        DIRECTORY_SIZE=$(numfmt --to=iec --suffix=B "$DIRECTORY_SIZE")
        INFO+=("${MAINCOLOR}| Directory size:${RESET} ${DIRECTORY_SIZE}")
    fi
}

function get_file_path {
    INFO+=("${MAINCOLOR}| Full file path:${RESET} $(pwd)/${path}")
}

function get_extenction {
    EXTENCTIONS="${path##*.}"
    INFO+=("${MAINCOLOR}| File type:${RESET} ${EXTENCTIONS}")
}

function get_creation_date {
    INFO+=("${MAINCOLOR}| Creation date:${RESET} $(date -d "$(stat -c %w "$path")" "+%Y-%m-%d %H:%M:%S")")
}

function get_last_modification_date {
    INFO+=("${MAINCOLOR}| Last modification date:${RESET} $(date -d "$(stat -c %y "$path")" "+%Y-%m-%d %H:%M:%S")")
}

function gap {
    INFO+=("${MAINCOLOR}|-------------------------------------${RESET}")
}

function get_all_files {
    INFO+=("${MAINCOLOR}| Number of all files in directory:${RESET} $(find "$path" -type f -printf '.' | wc -c)")
}

function get_ascii {
    if [ -f "${path}" ]; then
        if file --mime-type "$path" | grep -qE 'image/(jpeg|png|gif|webp|bmp|tiff)'; then
            SELECTED_ASCII=("${PHOTO_ASCII[@]}")
        else
            SELECTED_ASCII=("${FILE_ASCII[@]}")
        fi
    elif [ -d "${path}" ]; then
        SELECTED_ASCII=("${DIRECTORY_ASCII[@]}")
    fi
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
    # INFO+=("${MAINCOLOR}| Author:${RESET} $(stat -c %U "$path")")
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
    INFO+=("${MAINCOLOR}|${RESET} ${RED}Error!${RESET}")
    gap
    INFO+=("${MAINCOLOR}|${RESET} File not found")
fi

get_ascii

#Print all data:
max=${#SELECTED_ASCII[@]}
if [ ${#INFO[@]} -gt $max ]; then
    max=${#INFO[@]}
fi

for ((i=0; i<max; i++)); do
    SELECTED_ASCII="${SELECTED_ASCII[$i]}"
    info="${INFO[$i]}"
    echo -e "${MAINCOLOR}${SELECTED_ASCII:-}""$RESET  ${info:-}"
done
echo