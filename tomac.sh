#!/usr/bin/env bash
script_name="tomac.sh"
logger -s "${script_name} : Initiated transfer of configuration to mac mini"
logfile="log-timesync-"$(date +"%m%d%Y-%H%M%S%Z")".log"
touch ${logfile}
ssh mini "rm -f ~/.kube/config" | tee -a ${logfile}
scp .kube/config mini:~/.kube/config | tee -a ${logfile}
logger -s "${script_name} : Transfer of configuration to mac mini completed."
