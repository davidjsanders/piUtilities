#!/usr/bin/env bash
#
# Setup
#
script_name="update.sh"
logger -s "${script_name} : Initiated apt update of Kubernetes cluster"
logfile="log-apt-update-at-"$(date +"%m%d%Y-%H%M%S%Z")".log"
touch ${logfile}
chmod 0600 ${logfile}
#
# Get key credentials
#
echo "" | tee -a $logfile
echo "The private key ${HOME}/.ssh/id_rsa must be used." | tee -a $logfile
ssh-add ${HOME}/.ssh/id_rsa
#
# Update master
#
updateCommand="echo; echo 'Updating '\$HOSTNAME; sudo apt-get update; sudo apt-get upgrade --yes --quiet; sudo apt-get dist-upgrade --yes --quiet; echo; echo 'Updated '\$HOSTNAME; echo"
#
echo "Updating master node." | tee -a $logfile
eval $updateCommand | tee -a $logfile
#
# node 1
#
echo "" | tee -a $logfile
echo "Updating pi-worker1 " | tee -a $logfile
ssh pi-worker1 $updateCommand | tee -a $logfile
#
# Join node 2
#
echo "" | tee -a $logfile
echo "Updating pi-worker2 " | tee -a $logfile
ssh pi-worker2 $updateCommand | tee -a $logfile
#
# Done.
#
logger -s "${script_name} : Update of Kubernetes cluster complete"
