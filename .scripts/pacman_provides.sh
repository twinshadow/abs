#!/bin/bash
FILENAME=".pacman_provides"

test -d .git || exit 1
if [ -f ".FILENAME" ]; then
    pacman -Sy
    pacman -Sql > "$FILENAME"
fi
