#!/usr/bin/env bash
script_name="spindown.sh"
logger -s "${script_name} : Initiated shutdown of Kubernetes cluster"
logfile="log-spindown-"$(date +"%m%d%Y-%H%M%S%Z")".log"
touch ${logfile}
chmod 0600 ${logfile}
echo "The private key ${HOME}/.ssh/id_rsa must be used." | tee -a $logfile
ssh-add ${HOME}/.ssh/id_rsa
echo "" | tee -a $logfile
echo "Removing pi-worker1 from the cluster" | tee -a $logfile
ssh pi-worker1 "sudo kubeadm reset" | tee -a $logfile
ssh pi-worker1 "rm -rf .kube" | tee -a $logfile
echo "" | tee -a $logfile
echo "Removing pi-worker2 from the cluster" | tee -a $logfile
ssh pi-worker2 "sudo kubeadm reset" | tee -a $logfile
ssh pi-worker2 "rm -rf .kube" | tee -a $logfile
echo "" | tee -a $logfile
echo "Removing the cluster" | tee -a $logfile
sudo kubeadm reset | tee -a $logfile
rm -rf $HOME/.kube | tee -a $logfile
rm $HOME/.mysecrets/join.txt
echo "Done." | tee -a $logfile
logger -s "${script_name} : Shutdown of Kubernetes cluster complete"
