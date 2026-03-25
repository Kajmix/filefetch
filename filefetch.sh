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
    "            "
    "            "
    "            "
)

# Colors:
GREEN="\033[32m"
RESET="\033[0m"

#All stored data:
INFO=(
    "${GREEN}| File name:${RESET} ${BASENAME}"
)

#Get photo resolution:
function get_pixels {
    resolution=$(file "${path}" | grep -o "[0-9]\+[[:space:]]*x[[:space:]]*[0-9]\+")
    INFO+=("${GREEN}| Resolution: ${RESET}${resolution}")
}

#Get file size:
function get_filesize {
    FILESIZE=$(stat -c%s "$path" | numfmt --to=iec --suffix=B)
    INFO+=("${GREEN}| File size:${RESET} ${FILESIZE}")
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

if [ -f "$path" ]; then
    clear
    gap
    get_file_path
    get_filesize
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
else
    INFO=()
    INFO+=("File not found")
fi
#Print all data:
for line in "${!INFO[@]}"; do
    echo -e "${GREEN}${ASCII[$line]}$RESET  ${INFO[$line]}"
done
echo