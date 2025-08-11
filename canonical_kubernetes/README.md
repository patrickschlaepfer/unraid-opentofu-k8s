# Canonical Kubernetes 

Basically followed the instructions from here https://ubuntu.com/kubernetes/install

## Steps to install 

### master/control node

On my very old hardware with 2 vCPUs and 8GB Ram per node, it took the master
around 16 minutes to start and getting ready.

Connecting to the control node. You should be logged in

    $ ssh kubeuser@<ip_control_node>

Disable swap

    $ sudo swapoff -a

Check which channels are currently available for K8s

    $ snap info k8s
 
    $ sudo snap install k8s --classic --channel=1.33-classic/stable

Bootstrap the cluster

    $ sudo k8s bootstrap

View status of the cluster

    $ sudo k8s status --wait-ready

This command will wait until the cluster indicates it is ready and then
display the current status. The command will time-out if the cluster das not reach
a ready state.

Inital staus will be

```
cluster status:           ready
control plane nodes:      10.3.1.221:6400 (voter)
high availability:        no
datastore:                k8s-dqlite
network:                  enabled
dns:                      enabled at 10.152.183.136
ingress:                  disabled
load-balancer:            disabled
local-storage:            enabled at /var/snap/k8s/common/rawfile-storage
gateway                   enabled
```

Show all running pods

    $ sudo k8s kubectl get all --all-namespaces

If the master/control node is ready,
get the token in order to join the worker

Still on the control/master-node. This has to be done for each node.

    $ sudo k8s get-join-token --worker

The command above will print a token, which you will need to join the nodes.

### Nodes

On the nodes, install the k8s snap

    $ sudo snap install k8s --classic --channel=1.33-classic/stable

Then still on the node, join the worker node

    $ sudo k8s join-cluster <join-token>

On the control node, check if the node got connected and is ready

```
$ sudo k8s kubectl get nodes
NAME          STATUS   ROLES                  AGE     VERSION
k8s-1         Ready    worker                 8m44s   v1.33.2
k8s-2         Ready    worker                 87s     v1.33.2
k8s-control   Ready    control-plane,worker   23m     v1.33.2
```

## install kubectl

On the control node

```
sudo snap install --classic --channel=1.33 kubectl
mkdir ~/.kube
sudo k8s config > ~/.kube/config
kubectl get namespaces # to test the credentials
```

Change to your local machine, as for this example my Mac and copy the kube-config
by `ssh`

    $ scp kubeuser@10.3.1.221:/home/kubeuser/.kube/config .

Test the connection

    $ kubectl get namespaces

## Remove worker label from control-plane

Use the control-plane only as control-plane. No work will be scheduled.

    $ sudo k8s kubectl label node "k8s-control" node-role.kubernetes.io/worker-
    $ kubectl taint node k8s-control node-role.kubernetes.io/etcd:NoExecute node-role.kubernetes.io/control-plane:NoSchedule
