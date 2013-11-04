#!/usr/bin/env python3

from subprocess import Popen, PIPE
from sys import exit
from os import listdir, path
from tempfile import TemporaryFile
import yaml

def pkg_dep_cmd(pkgbuild):
    """
    Returns a string for the bash-command to generate the yaml-formatted
    package dependency graph.
    """
    return r"""
PKG_DIR_NAME="%s"
test -f "${PKG_DIR_NAME}/PKGBUILD" || exit 1
source "${PKG_DIR_NAME}/PKGBUILD"

echo "provides:"
for f in ${pkgname[*]} ${provides[*]}; do
    echo "  - $f"
done

echo "depends:"
for f in ${depends[*]} ${makedepends[*]}; do
    echo "  - $f"
done
echo ''
""" % (pkgbuild,)


def dirlist(directory):
    """
    Wrapper around listdir to return only visible directories.
    """
    return [filename for filename in listdir(directory)
            if (not filename.startswith('.')) and path.isdir(filename)]


def gen_dep_graph_file(filename):
    """
    Go through all directories and generate the package dependency graph,
    writing to the given file.
    """
    dump_ds = dict()
    pack_ds = dump_ds["packages"] = dict()
    prov_ds = dump_ds["provides"] = dict()
    deps_ds = dump_ds["depends"] = dict()
    for dirname in dirlist('.'):
        proc = Popen(("bash", "-c", pkg_dep_cmd(dirname)), stdout=PIPE)
        temp_ds = yaml.load(proc.communicate()[0])
        if temp_ds:
            pack_ds[dirname] = temp_ds
            for prov in temp_ds["provides"]:
                if prov not in prov_ds:
                    prov_ds[prov] = list()
                prov_ds[prov].append(dirname)
            for deps in temp_ds["depends"]:
                if deps not in deps_ds:
                    deps_ds[deps] = list()
                deps_ds[deps].append(dirname)

    with open(filename, "w") as dest_fd:
        dest_fd.write(yaml.dump(dump_ds, default_flow_style=False))


def usage(msg):
    exit(msg)

def main():
    gen_dep_graph_file(".dep_graph")

if __name__ == "__main__":
    if not path.isdir(".git"):
        usage("Run this from the top-level of the ABS directory")
    main()
