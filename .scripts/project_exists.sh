#!/bin/bash

project_exists () {
    project="$1"
    test -z "$project" && {
        echo "No project specified";
        return 1;
    }

    test -d "$project" || {
        echo "The project path does not exist: $project";
        return 2;
    }

    test -e "$project/PKGBUILD" || {
        echo "The project PKGBUILD is missing: $project";
        return 3;
    }
}

test "$0" = "$BASH_SOURCE" &&
    project_exists "$1" ||
    true
