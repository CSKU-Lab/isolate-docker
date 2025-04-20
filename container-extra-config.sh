#!/bin/bash

# Disable swap memory
swapoff -a

# Disable address space layout randomization
echo 0 > /proc/sys/kernel/randomize_va_space 2> /dev/null

# Disable transparent huge pages (THP)
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag 2> /dev/null

# Disable THP defragmentation
echo never > /sys/kernel/mm/transparent_hugepage/defrag 2> /dev/null

# Disable THP in general
echo never > /sys/kernel/mm/transparent_hugepage/enabled 2> /dev/null

# Disable CPU frequency scaling
echo core > /proc/sys/kernel/core_pattern 2> /dev/null

/bin/bash -c "$@"
