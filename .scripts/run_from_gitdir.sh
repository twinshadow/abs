#!/bin/bash

test -d ".git" || {
    echo "This script needs to be run from the repository root directory.";
    exit 1;
}
