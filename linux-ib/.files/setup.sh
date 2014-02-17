#!/bin/bash

test -d .files || {
    echo "This should be run from the package directory to be updated";
    exit 1;
}

rm -rf *
if [ -d .svnpkg ]; then
    svn up .svnpkg
else
    svn checkout svn://svn.archlinux.org/packages/linux/trunk .svnpkg
fi
cp .svnpkg/* .

cp PKGBUILD PKGBUILD-tmp
sed -i -e '/^pkgbase/d'                                                            \
       -e 's/^#\(pkgbase=linux\)-custom/\1-infiniband/g'                           \
       -e "/^makedepends=/s/\('xmlto'\|'docbook-xsl'\)\s*//g"                      \
       -e 's/^\(\s*pkgdesc.*modules\)"$/\1 with InfiniBand drivers and headers"/g' \
       -e '/^_package-docs() {/,/^}/D'                                             \
       -e '/^_package() {/,/^}/s/^}/  # linux-infiniband-headers/'                 \
       -e '/^_package-headers() {/,/^$/D'                                          \
       -e 's/^_package/package/'                                                   \
       -e 's|${pkgbase/linux/Linux}|Linux|'                                        \
       -e '/^pkgname=/,/^$/D'                                                      \
       -e '/^pkgbase/i pkgname=linux-infiniband'                                   \
       -e '/  \(provides\|depends\|replaces\|\)=("kernel26/D'                      \
       PKGBUILD-tmp

sed -i -e '/# Maintainer:/,/^$/!b;/^$/i\# Maintainer: Anthony Cornehl <accornehl[at]gmail[dot]com>\
# https://github.com/twinshadow/abs' PKGBUILD-tmp

patch < .files/infiniband-config.patch || exit 1
patch < .files/infiniband-config.x86_64.patch || exit 1

MD5SRC="$(makepkg -g)"
test "$?" = 0 || exit 1;
MD5SRC="$(echo $MD5SRC | tr '\n' '\t')"
sed -i -e '/^md5sums=(/,/)/d' -e "/source=(/,/^$/!b;/^$/i\\$(echo $MD5SRC)" PKGBUILD-tmp
sed -i -e '/^md5sums=(/s/\ /\n         /g' PKGBUILD-tmp
cp PKGBUILD-tmp PKGBUILD
