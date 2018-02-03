#!/usr/bin/env bash
script_name="restartcluster.sh"
logger -s "${script_name} : Initiated reboot of Kubernetes cluster"
logfile="log-restartcluster-"$(date +"%m%d%Y-%H%M%S%Z")".log"
touch ${logfile}
chmod 0600 ${logfile}
echo "The private key ${HOME}/.ssh/id_rsa must be used." | tee -a $logfile
ssh-add ${HOME}/.ssh/id_rsa
echo "" | tee -a $logfile
echo "Restarting pi-worker1" | tee -a $logfile
ssh pi-worker1 "sudo reboot now" | tee -a $logfile
echo "" | tee -a $logfile
echo "Restarting pi-worker2" | tee -a $logfile
ssh pi-worker2 "sudo reboot now" | tee -a $logfile
echo "" | tee -a $logfile
echo "Restarting this node (pi-master)" | tee -a $logfile
logger -s "${script_name} : Reboot of Kubernetes cluster complete"
sudo reboot now
