#!/usr/bin/env python3

from subprocess import Popen, PIPE
from sys import exit

blank_cksums = [
    "md5sums=(0)\n",
    "sha512sums=(0)\n",
]

with open("PKGBUILD") as fd:
    pkgbuild = fd.readlines()

top = pkgbuild[:pkgbuild.index("# cksum start\n") + 1]
bot = pkgbuild[pkgbuild.index("# cksum end\n"):]

with open("PKGBUILD", 'w') as fd:
    fd.writelines(top + blank_cksums + bot)

proc = Popen(("makepkg", "-g"), stdout=PIPE)
cksums = proc.communicate()[0].decode().splitlines(True)
if proc.returncode != 0:
    exit(proc.returncode)

with open("PKGBUILD", 'w') as fd:
    fd.writelines(top + cksums + bot)
