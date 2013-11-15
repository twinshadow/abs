#!/bin/bash

source "$1/PKGBUILD"

for str in \
  pkgname  \
  pkgdesc  \
  pkgver   \
  pkgrel   \
  url      \
  ;do
    test "${!str}" &&
      echo "$str: '${!str}'"
done

for arr in     \
  groups       \
  arch         \
  depends      \
  optdepends   \
  builddepends \
  source       \
  md5sums      \
  sha1sums     \
  sha256sums   \
  sha512sums; do
    test "${!arr}" || continue
    array=$arr[@] array=( ${!array} )
    echo "$arr: "
    for g in ${!array[@]}; do
      echo "    - '${array[$g]}'"
    done
done

echo "license:"
for str in ${!license[@]}; do
    echo "    - '${license[$str]}'"
done

echo "package_functions:"
for str in $(declare -f | sed -n 's/^\s*\(package_\S\+\|package\).*/\1/p;'); do
    echo "    - '$str'"
done
