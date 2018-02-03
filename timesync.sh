#!/usr/bin/env bash
script_name="timesync.sh"
logger -s "${script_name} : Initiated time sync. of Kubernetes cluster"
logfile="log-timesync-"$(date +"%m%d%Y-%H%M%S%Z")".log"
touch ${logfile}
chmod 0600 ${logfile}
echo "The private key ${HOME}/.ssh/id_rsa must be used." | tee -a $logfile
ssh-add ${HOME}/.ssh/id_rsa
syncCommand="sudo service ntp stop; sudo ntpdate -s time.nrc.ca; echo -n \$(hostname)' : ' ; echo \$(date); sudo service ntp start"
echo "" | tee -a $logfile
echo -n "Synchronizing pi-master with time.nrc.ca  : " | tee -a $logfile
ssh pi-master $syncCommand | tee -a $logfile
echo -n "Synchronizing pi-worker1 with time.nrc.ca : " | tee -a $logfile
ssh pi-worker1 $syncCommand | tee -a $logfile
echo -n "Synchronizing pi-worker2 with time.nrc.ca : " | tee -a $logfile
ssh pi-worker2 $syncCommand | tee -a $logfile
echo "" | tee -a $logfile
echo "Done." | tee -a $logfile
logger -s "${script_name} : Time sync. of Kubernetes cluster complete."
