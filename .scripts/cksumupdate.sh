#!/bin/sh

cp PKGBUILD PKGBUILD-tmp
MD5SRC="$(makepkg -g)"
test "$?" = 0 || exit 1;
MD5SRC="$(echo $MD5SRC | tr '\n' '\t')"
sed -i -e '/^md5sums=(/,/)/d' \
       -e '/^sha512sums=(/,/)/d' PKGBUILD-tmp

sed -i -e "/source=(/,/^$/!b;/^$/i\\$(echo $MD5SRC)" PKGBUILD-tmp

sed -i -e '/md5sums=(/s/\ /\n/g' \
       -e '/sha512sums=(/s/\ /\n/g' PKGBUILD-tmp

cp PKGBUILD-tmp PKGBUILD
rm PKGBUILD-tmp
