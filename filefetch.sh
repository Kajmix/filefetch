#!/bin/bash
FILENAME="$1"
if [ -f "$FILENAME" ]; then
    FILESIZE=$(stat -c%s "$FILENAME" | numfmt --to=iec --suffix=B)
    echo "File name: ${FILENAME}"
    echo "File size: ${FILESIZE}"
    if [[ "$FILENAME" == *.* ]]; then
        EXTENCTIONS="${FILENAME##*.}"
        echo "File type: ${EXTENCTIONS}";
    fi
    echo -e "Creation date: $(date -d "$(stat -c %w "$FILENAME")" "+%Y-%m-%d %H:%M:%S")"
else
    echo "File not found"
fi