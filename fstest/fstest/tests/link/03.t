#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/link/03.t,v 1.1 2007/01/17 01:42:09 pjd Exp $

desc="link returns ENAMETOOLONG if an entire length of either path name exceeded 1023 characters"

dir=`dirname $0`
. ${dir}/../misc.sh

case "${os}:${fs}" in
Darwin:*)
    # This test creates an unremovable file on Darwin:HFS+; so disable it!
    quick_exit
    ;;
*)
    echo "1..16"

    n0=`namegen`

    expect 0 mkdir ${name255} 0755
    expect 0 mkdir ${name255}/${name255} 0755
    expect 0 mkdir ${name255}/${name255}/${name255} 0755
    expect 0 mkdir ${path1021} 0755
    expect 0 create ${path1023} 0644
    expect 0 link ${path1023} ${n0}
    expect 0 unlink ${path1023}
    expect 0 link ${n0} ${path1023}
    expect 0 unlink ${path1023}
    create_too_long
    expect ENAMETOOLONG link ${n0} ${too_long}
    unlink_too_long
    expect 0 unlink ${n0}
    create_too_long
    expect ENAMETOOLONG link ${too_long} ${n0}
    unlink_too_long
    expect 0 rmdir ${path1021}
    expect 0 rmdir ${name255}/${name255}/${name255}
    expect 0 rmdir ${name255}/${name255}
    expect 0 rmdir ${name255}
esac
