# Canonical Kubernetes 

Basically followed the instructions from here https://ubuntu.com/kubernetes/install

## Steps to install 

### master/control node

On my very old hardware with 2 vCPUs and 8GB Ram per node, it took the master
around 16 minutes to start and getting ready.
 
    $ sudo snap install k8s --classic

Bootstrap the cluster

    $ sudo k8s bootstrap

View status of the cluster

    $ sudo k8s status

If the master/control node is ready,
get the token in order to join the worker

Still on the control/master-node

    $ sudo k8s get-join-token --worker

The command above will print a token, which you will need to join the nodes.

### Nodes

On the nodes, install the k8s snap

    $ sudo snap install k8s --classic

Then still on the node, join the worker node

    $ sudo k8s join-cluster

On the control node, check if the node got connected and is ready

```
sudo k8s kubectl get nodes
NAME          STATUS   ROLES                  AGE     VERSION
k8s-1         Ready    worker                 6m39s   v1.32.6
k8s-control   Ready    control-plane,worker   32m     v1.32.6
```

 



