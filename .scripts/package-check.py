#!/usr/bin/env python2
import urllib2
import urlparse
import sys
import os
from subprocess import Popen, PIPE

{"http":
        {"www.openfabrics.org":
                {"/downloads/cxgb3": [{
                    "source": "libcxgb3-([a-zA-Z0-9.]*?).tar.gz", "cksum": "libcxgb3-([a-zA-Z0-9.]*?)-md5sum.txt"}],
                 "/downloads/cxgb4": [{
                     "source": "libcxgb4-([a-zA-Z0-9.]*?).tar.gz",
                     "cksum": ""}],
                 "/downloads/dapl":  [{
                     "source": "dapl-([a-zA-Z0-9.]*?).tar.gz",
                     "cksum": ""}],
                 "/downloads/ibutils": [{
                     "source": "ibutils-([a-zA-Z0-9.]*?).tar.gz",
                     "cksum": ""}],
                 "/downloads/libipathverbs": [{
                     "source": "libipathverbs-([a-zA-Z0-9.]*?).tar.gz", "cksum": "" }],
                 "/downloads/libsdp": [{
                     "source": "libsdp-([a-zA-Z0-9.]*?).tar.gz", "cksum": ""}],
                 "/downloads/management": [
                     {"libibmad-([a-zA-Z0-9.]*?).tar.gz", "cksum": "" },
                     {"libibumad-([a-zA-Z0-9.]*?).tar.gz", "cksum": "" },
                     {"opensm-([a-zA-Z0-9.]*?).tar.gz", "cksum": "" }],
                 "/downloads/mlx4": [{
                     "source": "libmlx4-([a-zA-Z0-9.]*?).tar.gz", "cksum": ""}],
                 "/downloads/mstflint": [{
                     "mstflint-([a-zA-Z0-9.]*?).tar.gz": }],
                 "/downloads/mthca": [{
                     "libmthca-([a-zA-Z0-9.]*?).tar.gz": }],
                 "/downloads/nes": [{
                     "libnes-([a-zA-Z0-9.]*?).tar.gz": }],
                 "/downloads/perftest": [{
                     "perftest-([a-zA-Z0-9.]*?).tar.gz": }],
                 "/downloads/rdmacm": [
                     {"ibacm-([a-zA-Z0-9.]*?).tar.gz": },
                     {"libibcm-([a-zA-Z0-9.]*?).tar.gz": },
                     {"librdmacm-([a-zA-Z0-9.]*?).tar.gz": }],
                 "/downloads/sdpnetstat": [{
                     "sdpnetstat-([a-zA-Z0-9.]*?).tar.gz": }],
                 "/downloads/verbs": [{
                     "libibverbs-([a-zA-Z0-9.]*?).tar.gz": }]}}}

