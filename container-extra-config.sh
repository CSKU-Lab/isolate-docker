#!/bin/bash

# Disable swap memory
swapoff -a

# Disable CPU frequency scaling
echo off > /sys/devices/system/cpu/smt/control

# Disable address space layout randomization
echo 0 > /proc/sys/kernel/randomize_va_space

# Disable transparent huge pages (THP)
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag

# Disable THP defragmentation
echo never > /sys/kernel/mm/transparent_hugepage/defrag

# Disable THP in general
echo never > /sys/kernel/mm/transparent_hugepage/enabled

# Disable CPU frequency scaling
echo core >/proc/sys/kernel/core_pattern

/bin/bash -c "$@"
