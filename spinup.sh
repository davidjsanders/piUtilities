#!/usr/bin/env bash
#
# Setup
#
script_name="spinup.sh"
logger -s "${script_name} : Initiated startup of Kubernetes cluster"
logfile="log-spinup-at-"$(date +"%m%d%Y-%H%M%S%Z")".log"
touch ${logfile}
chmod 0600 ${logfile}
#
# Get key credentials
#
echo "" | tee -a $logfile
echo "The private key ${HOME}/.ssh/id_rsa must be used." | tee -a $logfile
ssh-add ${HOME}/.ssh/id_rsa
#
# Run kubeadm
#
echo "" | tee -a $logfile
sudo kubeadm init \
   --token-ttl=0 \
   --apiserver-advertise-address='192.168.86.100' \
   | tee -a $logfile
#
# Create .kube
#
mkdir -p ${HOME}/.kube
rm -f ${HOME}/.kube/config
sudo cp -i /etc/kubernetes/admin.conf ${HOME}/.kube/config
sudo chown $(id -u):$(id -g) ${HOME}/.kube/config
#
# Setup networking with Weave
#
echo "Setting up networking (Weave 1.6)" | tee -a $logfile
echo "" | tee -a $logfile
kubectl apply -f https://git.io/weave-kube-1.6 | tee -a $logfile
#
# Get the jointoken from the logfile
#
jointoken="sudo "$(cat ${logfile} | grep "kubeadm join")
if [[ $jointoken == "sudo " ]];
then
    echo "ERROR! For some reason the join token could NOT be found in the log" | tee -a $logfile
    exit 1
fi
mkdir -p ${HOME}/.mysecrets
rm -f ${HOME}/.mysecrets/join.txt
echo "" | tee -a $lofile
echo "Writing join token --> sudo ${jointoken}" | tee -a $lofile
echo "" | tee -a $lofile
echo $jointoken > ${HOME}/.mysecrets/join.txt
chmod 0600 ${HOME}/.mysecrets/join.txt
#
# Join node 1
#
echo "" | tee -a $logfile
echo "Joining pi-worker1 to the cluster" | tee -a $logfile
ssh pi-worker1 $jointoken | tee -a $logfile
ssh pi-worker1 "mkdir -p .kube" | tee -a $logfile
#
# Join node 2
#
echo "" | tee -a $logfile
echo "Joining pi-worker2 to the cluster" | tee -a $logfile
ssh pi-worker2 $jointoken | tee -a $logfile
ssh pi-worker2 "mkdir -p .kube" | tee -a $logfile
#
# Copy configuration files
#
echo "" | tee -a $logfile
echo "Copying configuration files" | tee -a $logfile
scp ${HOME}/.kube/config pi-worker1:~/.kube/ | tee -a $logfile
scp ${HOME}/.kube/config pi-worker2:~/.kube/ | tee -a $logfile
echo "" | tee -a $logfile
#
# Setup dashboard
#
echo "" | tee -a $logfile
echo "Setting up K8S dashboard for ARM" | tee -a $logfile
kubectl apply -f /home/pi/Documents/dev/k8dashboard-arm/cluster-role-binding.yaml
kubectl apply -f /home/pi/Documents/dev/k8dashboard-arm/admin-user.yaml
kubectl apply -f /home/pi/Documents/dev/k8dashboard-arm/kubernetes-dashboard.yaml
echo "Done. Use /home/pi/Documents/dev/k8dashboard-arm/show-token.sh to view admin user token." | tee -a $logfile
#
# Done.
#
logger -s "${script_name} : Startup of Kubernetes cluster complete"
