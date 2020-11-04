#!/bin/bash

COUNTER_FILE="/usr/local/share/step-counter.txt"

if [ ! -f "$COUNTER_FILE" ]; then
  echo "0" > $COUNTER_FILE
fi

COUNTER=`head -n 1 $COUNTER_FILE`
COUNTER=`expr $COUNTER + 1`
echo "$COUNTER" > $COUNTER_FILE

clear
