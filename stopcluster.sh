#!/usr/bin/env bash
script_name="stopcluster.sh"
logger -s "${script_name} : Initiated shutdown of Kubernetes cluster"
logfile="log-stopcluster-"$(date +"%m%d%Y-%H%M%S%Z")".log"
touch ${logfile}
chmod 0600 ${logfile}
echo "The private key ${HOME}/.ssh/id_rsa must be used." | tee -a $logfile
ssh-add ${HOME}/.ssh/id_rsa
echo "" | tee -a $logfile
echo "Shutting down pi-worker1" | tee -a $logfile
ssh pi-worker1 "sudo shutdown -P now" | tee -a $logfile
echo "" | tee -a $logfile
echo "Shutting down pi-worker2" | tee -a $logfile
ssh pi-worker2 "sudo shutdown -P now" | tee -a $logfile
echo "" | tee -a $logfile
echo "Shutting down this node (pi-master)" | tee -a $logfile
logger -s "${script_name} : Shutdown of Kubernetes cluster complete"
sudo shutdown -P now
