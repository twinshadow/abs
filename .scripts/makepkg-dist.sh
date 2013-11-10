#!/bin/bash
PROJECT="$1"
MAKEPKG=${MAKEPKG:-makepkg}
CPUARCH="$(lscpu | sed -n 's/Architecture:\s\+\(.*\)/\1/p')"
SCRIPTS="$PWD/.scripts"

export PACKAGER="Anthony Cornehl <accornehl[at]gmail[dot]com>"
export MAKEFLAGS="-j$(grep -c processor /proc/cpuinfo)"
export PACMAN=${PACMAN:-pacaur}
export PKGDEST="$PWD/.pkgdir"
export SRCPKGDEST="$PKGDEST"
mkdir -p "$PKGDEST"

test -d ".git" || {
    echo "This script needs to be run from the repository root directory.";
    exit 1;
}

test -d "$PROJECT" || {
    echo "The given project does not exist: $PROJECT";
    exit 1;
}

cd "$PROJECT"
"$MAKEPKG" --syncdeps --noconfirm --noprogressbar --clean --force
"$MAKEPKG" --source --force
cd -
