#!/bin/bash
#
# Copyright © 2018-2021 Inria.  All rights reserved.
# $COPYRIGHT$
#

PID=$1
if cat /proc/$PID/environ 2>/dev/null | grep -q OMPI_COMM_WORLD_RANK
then
  cat /proc/$PID/environ 2>/dev/null | xargs --null --max-args=1 echo | grep OMPI_COMM_WORLD_RANK | grep -oP '[^=]*$'
else
  if cat /proc/$PID/environ 2>/dev/null | grep -q PMIX_RANK
  then
    cat /proc/$PID/environ 2>/dev/null | xargs --null --max-args=1 echo | grep PMIX_RANK | grep -oP '[^=]*$'
  else
    if cat /proc/$PID/environ 2>/dev/null | grep -q PMI_RANK
    then
      cat /proc/$PID/environ 2>/dev/null | xargs --null --max-args=1 echo | grep PMI_RANK | grep -oP '[^=]*$'
    else
      cat /proc/$PID/environ 2>/dev/null | xargs --null --max-args=1 echo | grep SLURM_PROCID | grep -oP '[^=]*$'
    fi
  fi
fi