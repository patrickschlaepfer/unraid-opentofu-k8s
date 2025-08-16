# kubernetes dashboard

All commands are executed on the mac.

A dashboard can't be that wrong

    $ helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

You might want to override some values, the values you will find here: 
https://github.com/kubernetes/dashboard/blob/master/charts/kubernetes-dashboard/values.yaml

```
helm template \
    kubernetes-dashboard \
    --namespace kubernetes-dashboard \
    --set crds.enabled=true \
    > kubernetes-dashboard.custom.yaml
```

    $ helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

Create a serviceaccount

    $ kubectl apply -f serviceaccount.yaml

Create a cluster role binding

    $ kubectl apply -f clusterrolebinding.yaml

Get the token

    $ kubectl -n kubernetes-dashboard create token admin-user

get svc/kubernetes-dashboard-web -n kubernetes-dashboard

http://10.3.1.230/