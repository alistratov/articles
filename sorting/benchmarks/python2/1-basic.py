#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

from fnmatch import fnmatch
from os import path, walk, chdir, getcwd
from zipfile import ZipFile

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
MAX_DEPTH = 5
ZF_NAME = "%s.zip"
GLOBAL_ALLOWED_FILES = ['har', 'tcpdump', 'shutter.log', 'shoot.log', 
                'outline.png', 'tr_*.png', 'results.csv', 'task.json']

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------
def allowed(fname, match_list):
    for pattern in match_list:
        if fnmatch(fname, pattern):
            return True
    return False

def add_files(zf, dpath, files, relpathstart, allowed=None, *args):
    for f in files:
        fpath = path.join(dpath, f)
        if not allowed or allowed(f, *args):
            frelpath = path.relpath(fpath, relpathstart)
            zf.write(frelpath)

def make_zip(dirpath, viewports):
    dirabs = path.abspath(dirpath)
    dirrelpath, dirname = path.split(dirabs)
    depth = 0
    # prepare allowed dirs, files, etc
    allowed_dirs = ['viewports'] if viewports else []
    allowed_files = GLOBAL_ALLOWED_FILES 
    # create zipfile
    zf_name = ZF_NAME % dirname
    zf = ZipFile(zf_name, 'w')
    # Remember and change working dir to archive
    orig_cwd = getcwd()
    chdir(dirrelpath)

    for dpath, dnames, fnames in walk(dirabs):
        if allowed(path.split(dpath)[1], allowed_dirs):
            add_files(zf, dpath, fnames, dirrelpath, None)
        else:
            add_files(zf, dpath, fnames, dirrelpath, allowed, allowed_files)
            
    zf.close()
    chdir(orig_cwd)
    print "%s contents:" % zf_name
    zf.printdir()
    return zf
                
# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
usage = "Harvests results from the given dirs into separate zip archives, " \
        "including results.cvs, HAR/pcap, logs, masked sequences\n\n" \
        "Usage:\nharvest [option] [dir1 dir2 ..]\n\n" \
        "Options:\n" \
        "\t-h\tShow this help\n" \
        "\t--viewports\tinclude viewports\n"
include_viewports = False
dirs = []

if len(sys.argv) < 2:
    sys.exit(usage)
elif len(sys.argv) >= 2:
    if sys.argv[1] == '--viewports':
        include_viewports = True
        dirs = sys.argv[2:]
    elif sys.argv[1] == '-h':
        sys.exit(usage)
    else:
        dirs = sys.argv[1:]
    
    # do zipping
    for d in dirs:
        make_zip(d, include_viewports) 
