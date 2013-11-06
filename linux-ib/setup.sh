svn checkout svn://svn.archlinux.org/packages/linux/trunk linux-svn
cp linux-svn/* .
sed -i -e '/^pkgbase/d;'\
          's/^#\(pkgbase=linux\)-custom/\1-infiniband/g;'\
          's/^\(\s*pkgdesc.*modules\)"$/\1 with InfiniBand drivers"/g;' PKGBUILD

sed -i -e '/^md5sums=(/,/)$/D' PKGBUILD
makepkg -g >> PKGBUILD
