#!/bin/sh
COUNTER_FILE="/usr/local/share/step-counter.txt"
if [ ! -f "$COUNTER_FILE" ]; then
  echo "0" > $COUNTER_FILE
  echo "Counter file $COUNTER_FILE created."
fi
COUNTER=`head -n 1 $COUNTER_FILE`
echo "Step was $COUNTER"
COUNTER=`expr $COUNTER + 1`
echo "Step advanced to $COUNTER"
echo "$COUNTER" > $COUNTER_FILE
