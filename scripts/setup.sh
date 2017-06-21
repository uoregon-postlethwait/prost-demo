#!/usr/bin/env sh

# This script sets up prost-demo for running.  It:
#   * Checks for presence of BBMap.
#   * Uncompresses samples files and annotation files.

set -e

# Is BBMap in PATH?
if [ ! `which bbmap.sh` ] ; then 
    echo Error: Cannot find bbmap.sh in your \$PATH.
    echo Please add the directory containing your download of BBMap to your \$PATH, like so:
    echo
    echo    export PATH=\$PATH:/path/to/bbmap/
    echo
    exit
fi

# Uncompress annotation files
cd ../fa
gunzip *

# Uncompress samples files
cd ../samples
gunzip *
