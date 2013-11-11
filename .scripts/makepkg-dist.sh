#!/bin/bash
PROJECT="$1"
MAKEPKG=${MAKEPKG:-/usr/bin/makepkg}
CPUARCH="$(lscpu | sed -n 's/Architecture:\s\+\(.*\)/\1/p')"
SCRIPTS="$PWD/.scripts"
NAMCAP="/usr/bin/namcap"

export PACKAGER
export MAKEFLAGS="-j$(grep -c processor /proc/cpuinfo)"
export PACMAN=${PACMAN:-/usr/bin/pacaur}
export PKGDEST="${PKGDEST:-.pkgdir}"
export SRCPKGDEST="$PKGDEST"

test -d ".git" || {
    echo "This script needs to be run from the repository root directory.";
    exit 1;
}

test -d "$PROJECT" || {
    echo "The given project does not exist: $PROJECT";
    exit 1;
}

mkdir -p "$PKGDEST"
cd "$PROJECT"
"$MAKEPKG" --syncdeps --noconfirm --noprogressbar --clean --force || exit $?
"$NAMCAP" "$PKGDEST"/*.pkg.tar.xz
"$MAKEPKG" --source --force
cd -
