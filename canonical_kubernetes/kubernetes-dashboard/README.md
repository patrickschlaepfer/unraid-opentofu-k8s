# kubernetes dashboard

All commands are executed on the mac.

A dashboard can't be that wrong

    $ helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    $ helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

The dashboard should then be available at https://localhost:8443

Create a serviceaccount

    $ kubectl apply -f serviceaccount.yaml

Create a cluster role binding

    $ kubectl apply -f clusterrolebinding.yaml

Get the token

    $ kubectl -n kubernetes-dashboard create token admin-user