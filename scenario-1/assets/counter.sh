#!/bin/bash
#
# This is a script that is executed for every scenario step
# when the step is being loaded. It helps to keep track of
# the current steps, which is useful when checking the
# scenario-status.
#

COUNTER_FILE="/usr/local/share/step-counter.txt"

if [ ! -f "$COUNTER_FILE" ]; then
  echo "0" > $COUNTER_FILE
fi

COUNTER=`head -n 1 $COUNTER_FILE`

echo $(expr $COUNTER + 1) > $COUNTER_FILE

# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
# Filling up. It seems there is a minimal size for asset files or they are ignored.
