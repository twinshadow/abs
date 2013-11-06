svn checkout svn://svn.archlinux.org/packages/linux/trunk linux-svn
cp linux-svn/* .
sed -i -e '/^pkgbase/d;' \
       -e 's/^#\(pkgbase=linux\)-custom/\1-infiniband/g;' \
       -e 's/^\(\s*pkgdesc.*modules\)"$/\1 with InfiniBand drivers"/g;' \
       -e '/^md5sums=(/,/)$/D' \
       -e "/^makedepends=/s/\('xmlto'\|'docbook-xsl'\)\s*//g" \
       -e 's/^pkgname=.*/pkgname=("${pkgbase}")/' PKGBUILD
makepkg -g >> PKGBUILD
