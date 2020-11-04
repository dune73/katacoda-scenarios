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

#JSON=/usr/local/etc/scenario-status.json
#
#STEPCOUNTERFILE=/usr/local/share/step-counter.txt
#
#TOTALSTEPS=8
#
#VERBOSE=0
#AUTOMATIC=0
#
#function vprint {
#        # print if verbose is set
#        if [ $VERBOSE -eq 1 ]; then
#                echo "$1"
#        fi
#}
#
#
#function usage {
#
#        echo
#        echo "`basename $0` [OPTIONS] "
#        echo
#        echo "A script to check the status of the teaching scenario."
#        echo
#        echo " -a --automatic    Automatic mode."
#        echo " -h --help         This text"
#	echo " -m --minstep STR  First step that should be checked."
#        echo " -s --step STR     Final step that should be checked."
#        echo " -v --verbose      Verbose output"
#        echo " -?                This text"
#	echo
#	echo "By default, all steps up to the value in the step-counter file"
#	echo "will be counted. The step-counter file is updated by Katacoda"
#	echo "and keeps track of the scenario steps as you advance."
#	echo 
#	echo "`basename $0` --step 5 will check from step 1 to step 5."
#	echo
#	echo "`basename $0` --minstep 5 will check from step 5 to the end of the scenario."
#	echo
#	echo "`basename $0` --minstep 5 --step 5 will check step 5."
#	echo
#	echo "The automatic mode is a separate mode used by Katacoda"
#	echo "scripts. It depends on an output of \"done\" on the final"
#	echo "line of the output. Katacoda will then determine that the"
#	echo "check was successful."
#        echo
#}
