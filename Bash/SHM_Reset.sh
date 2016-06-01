#!/bin/bash
# Brian Lynch 06/01/2016
# This script will search for shared memory spaces with no processes attached
# and then delete them. This is useful when developing code with shared memory
# and you end up with "lost" shared memory spaces you can no longer attach to.

echo '---------------Running SHM_Reset.sh---------------'

# Get the current username
ME=`whoami`

# Find all shared memory and check for # attached processes. If zero, store ID
IPCS_M=`ipcs -m | egrep "0x[0-9a-f]+ [0-9]+"|awk '{ if ($6 == 0) { print $2; } }'`

# Loop through the ID's with zero processes and delete them
for id in $IPCS_M; do
  echo "Removing shared memory with ID: " $id
  ipcrm -m $id;
done

echo '---------------Exiting SHM_Reset.sh---------------'
