#!/bin/bash
#
# Copyright © 2018-2021 Inria.  All rights reserved.
# $COPYRIGHT$
#

function die() {
  echo "$@"
  exit 1
}

completion_file="./contrib/completion/bash/hwloc"
files="utils/hwloc/hwloc-annotate.c|
      utils/hwloc/hwloc-bind.c|
      utils/hwloc/hwloc-calc.c|
      utils/hwloc/hwloc-diff.c|
      utils/hwloc/hwloc-distrib.c|
      utils/hwloc/hwloc-info.c|
      utils/hwloc/hwloc-patch.c|
      utils/hwloc/hwloc-ps.c|
      utils/lstopo/lstopo.c"

git diff-index --cached --name-only HEAD | grep -E $files | while read -r file ; do
    git diff --staged ../../$file | grep -oP '((\+  .+)\K(--[\S]+))(?=\\| )' | while read -r option ; do
      in_file=${file/.c/.1in}
      in_option=${option//-/\\\\-}
      
      if ! grep -q -- "$option" $completion_file; then
        die "ERROR : Failed to find $option in $completion_file."
      elif ! grep -q -- "$in_option" $in_file ; then
        die "ERROR : Failed to find $option in $in_file."
      fi
    done
done

  

