#!/bin/bash
FILENAME="$1"

INFO=(
    "| File name: ${FILENAME}"
)

function gap {
    INFO+=("|-------------------------------------")
}

if [ -f "$FILENAME" ]; then
    FILESIZE=$(stat -c%s "$FILENAME" | numfmt --to=iec --suffix=B)
    gap
    INFO+=("| File size: ${FILESIZE}")
    if [[ "$FILENAME" == *.* ]]; then
        EXTENCTIONS="${FILENAME##*.}"
        INFO+=("| File type: ${EXTENCTIONS}")
    fi
    INFO+=("| Author: $(stat -c %U "$FILENAME")")
    INFO+=("| Creation date: $(date -d "$(stat -c %w "$FILENAME")" "+%Y-%m-%d %H:%M:%S")")
    INFO+=("| Last modification date: $(date -d "$(stat -c %y "$FILENAME")" "+%Y-%m-%d %H:%M:%S")")
    if [[ "$EXTENCTIONS" == "png" || "$EXTENCTIONS" == "jpg" || "$EXTENCTIONS" == "raw" || "$EXTENCTIONS" == "webp" ]]; then
        INFO+=("| (Soon)")
    fi
else
    echo "File not found"
fi
clear
for line in "${INFO[@]}"; do
    printf "%s\n" "$line"
done
echo
echo