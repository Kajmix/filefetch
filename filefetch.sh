#!/bin/bash
FILENAME="$1"

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
INFO=(
    "${GREEN}| File name:${RESET} ${FILENAME}"
)

function get_pixels {
    resolution=$(file "${FILENAME}" | grep -o "[0-9]\+[[:space:]]*x[[:space:]]*[0-9]\+")
    INFO+=("${GREEN}| Resolution: ${RESET}${resolution}")
}

function gap {
    INFO+=("${GREEN}|-------------------------------------${RESET}")
}

if [ -f "$FILENAME" ]; then
    clear
    #Get file size:
    FILESIZE=$(stat -c%s "$FILENAME" | numfmt --to=iec --suffix=B)

    gap
    INFO+=("${GREEN}| Full file path: $(pwd)/${FILENAME}")
    INFO+=("${GREEN}| File size:${RESET} ${FILESIZE}")
    
    #checks if file has extenction
    if [[ "$FILENAME" == *.* ]]; then
        EXTENCTIONS="${FILENAME##*.}"
        INFO+=("${GREEN}| File type:${RESET} ${EXTENCTIONS}")
    fi
    INFO+=("${GREEN}| Author:${RESET} $(stat -c %U "$FILENAME")")
    INFO+=("${GREEN}| Creation date:${RESET} $(date -d "$(stat -c %w "$FILENAME")" "+%Y-%m-%d %H:%M:%S")")
    INFO+=("${GREEN}| Last modification date:${RESET} $(date -d "$(stat -c %y "$FILENAME")" "+%Y-%m-%d %H:%M:%S")")
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