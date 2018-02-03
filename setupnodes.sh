#!/usr/bin/env bash
script_name="setupnodes.sh"
logger -s "${script_name} : Enabling kubectl on Kubernetes cluster nodes"
logfile=${HOME}"/log-setupnodes-at-"$(date +"%H%M%S%Z")".log"
echo "Setting up remote nodes" | tee $logfile
ssh-add $HOME/.ssh/id_rsa
ssh pi-worker1 "mkdir -p .kube" | tee -a $logfile
ssh pi-worker2 "mkdir -p .kube" | tee -a $logfile
scp .kube/config pi-worker1:~/.kube/ | tee -a $logfile
scp .kube/config pi-worker2:~/.kube/ | tee -a $logfile
echo "Setting up remote nodes completed" | tee -a $logfile
logger -s "${script_name} : kubectl enabled on Kubernetes cluster nodes complete"
