#!/bin/bash
PROJECT="$1"
ACTION="$2"
MAKEPKG=${MAKEPKG:-/usr/bin/makepkg}
CPUARCH="$(lscpu | sed -n 's/Architecture:\s\+\(.*\)/\1/p')"
SCRIPTS="$PWD/.scripts"
NAMCAP="/usr/bin/namcap"
PACMAN_FLAGS="--noconfirm --noprogressbar"
PKGEXT='.pkg.tar.xz'
SRCEXT='.src.tar.gz'

export PACMAN=${PACMAN:-/usr/bin/pacaur}
export MAKEFLAGS="-j$(grep -c processor /proc/cpuinfo)"

test -d ".git" || {
    echo "This script needs to be run from the repository root directory.";
    exit 1;
}

test -d "$PROJECT" || {
    echo "The given project does not exist: $PROJECT";
    exit 1;
}

for dep in $(bash -c "source $PROJECT/PKGBUILD; echo \${depends[*]}"); do
    if [ -d "$dep" ] && [ "$PACMAN -T $dep" ]; then
        $SCRIPTS/makepkg-dist.sh $dep install
    fi
done

export PACKAGER
export PKGDEST="${PKGDEST:-$PWD/.pkgdir}"
export SRCPKGDEST="$PKGDEST"
mkdir -p "$PKGDEST"

cd "$PROJECT"
rm -rf *$PKGEXT *$SRCEXT
"$MAKEPKG" --syncdeps $PACMAN_FLAGS --clean --force || { cd -; exit $?; }
case "$ACTION" in
    install)
        echo "$PACMAN" -U $PACMAN_FLAGS --asdeps *$PKGEXT;
        "$PACMAN" -U $PACMAN_FLAGS --asdeps *$PKGEXT;
        ;;
    *)
        "$NAMCAP" "$PKGDEST"/*$PKGEXT;
        "$MAKEPKG" --source --force;
        ;;
esac
cd -
