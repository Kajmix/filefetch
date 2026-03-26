#!/bin/bash
path="$1"
FILENAME="${path##*/}"
BASENAME="${FILENAME%.*}"

IsFile=false
IsDirectory=false

if [ -f "${path}" ]; then
    IsFile=true
elif [ -d "${path}" ]; then
    IsDirectory=true
fi

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

#=-=-=Config=-=-=-

#Here u can set color:
MAINCOLOR="${GREEN}"

#false = just file name without extenction | true = file name with extenction
Show_extensions=false

#=-=-=-=-=-=-=-=-=-=
#All stored data:
INFO=()

function get_name {
    if [ "${IsFile}" == true ]; then
        if [ "${Show_extensions}" == true ]; then
            NAME="$FILENAME"
        else
            NAME="$BASENAME"
        fi
        INFO+=("${MAINCOLOR}| File name:${RESET} $NAME")
    elif [ "${IsDirectory}" == true ]; then
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
    if [ "${IsFile}" == true ]; then
        FILESIZE=$(stat -c%s "$path" | numfmt --to=iec --suffix=B)
        INFO+=("${MAINCOLOR}| File size:${RESET} ${FILESIZE}")
    elif [ "${IsDirectory}" == true ]; then
        DIRECTORY_SIZE=$(du -sb "$path" 2>/dev/null | cut -f1)
        DIRECTORY_SIZE=$(numfmt --to=iec --suffix=B "$DIRECTORY_SIZE")
        INFO+=("${MAINCOLOR}| Directory size:${RESET} ${DIRECTORY_SIZE}")
    fi
}

function get_file_path {
    INFO+=("${MAINCOLOR}| Full file path:${RESET} $(pwd)/${path}")
}

function get_extenction {
    EXTENSIONS="${path##*.}"
    INFO+=("${MAINCOLOR}| File type:${RESET} ${EXTENSIONS}")
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
    if [ "${IsFile}" == true ]; then
        if file --mime-type "$path" | grep -qE 'image/(jpeg|png|gif|webp|bmp|tiff)'; then
            SELECTED_ASCII=("${PHOTO_ASCII[@]}")
        else
            SELECTED_ASCII=("${FILE_ASCII[@]}")
        fi
    elif [ "${IsDirectory}" == true ]; then
        SELECTED_ASCII=("${DIRECTORY_ASCII[@]}")
    fi
}
# Section for files:
if [ "${IsFile}" == true ]; then
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
    if [[ "$EXTENSIONS" == "png" || "$EXTENSIONS" == "jpg" || "$EXTENSIONS" == "raw" || "$EXTENSIONS" == "webp" ]]; then
        get_pixels
    fi
elif [ "${IsDirectory}" == true ]; then
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
echo ""