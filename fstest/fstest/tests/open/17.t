#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/open/17.t,v 1.1 2007/01/17 01:42:10 pjd Exp $

desc="open returns ENXIO when O_NONBLOCK is set, the named file is a fifo, O_WRONLY is set, and no process has the file open for reading"

dir=`dirname $0`
. ${dir}/../misc.sh

echo "1..3"

n0=`namegen`

expect 0 mkfifo ${n0} 0644
case "${os}:${fs}" in
Darwin:secfs|Darwin:cgofuse)
    # This appears to be a problem in OSXFUSE; secfs-fuse does not even see the open() call.
    expect EPERM open ${n0} O_WRONLY,O_NONBLOCK
    ;;
*)
    expect ENXIO open ${n0} O_WRONLY,O_NONBLOCK
    ;;
esac
expect 0 unlink ${n0}