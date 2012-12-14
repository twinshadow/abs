#!/usr/bin/env python3
import os
cksums = os.popen("makepkg -g").read().splitlines()
fd = open("PKGBUILD")
pkgbuild = fd.read().splitlines()
fd.close()

start = pkgbuild.index("# cksum start")
end = pkgbuild.index("# cksum end")
if start and end:
    foo = pkgbuild[:start + 1]
    foo += cksums
    foo += pkgbuild[end:]
    fd = open("PKGBUILD", "w")
    fd.write('\n'.join(foo))
    fd.close()
