# Gateway

On the control node

    $ sudo k8s kubectl get GatewayClass

    $ kubectl apply -f 00_...

```
$ kubectl get all -owide
od/my-nginx-6d596599f5-4gx7x   1/1     Running   0          103s   10.1.1.205   k8s-1   <none>           <none>

NAME                                TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE   SELECTOR
service/cilium-gateway-my-gateway   LoadBalancer   10.152.183.103   <pending>     80:30315/TCP   92s   <none>
service/kubernetes                  ClusterIP      10.152.183.1     <none>        443/TCP        24m   <none>
service/my-nginx                    ClusterIP      10.152.183.109   <none>        80/TCP         96s   run=my-nginx

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS   IMAGES                            SELECTOR
deployment.apps/my-nginx   1/1     1            1           103s   my-nginx     ghcr.io/containerd/nginx:1.27.0   run=my-nginx

NAME                                  DESIRED   CURRENT   READY   AGE    CONTAINERS   IMAGES                            SELECTOR
replicaset.apps/my-nginx-6d596599f5   1         1         1       103s   my-nginx     ghcr.io/containerd/nginx:1.27.0   pod-template-hash=6d596599f5,run=my-nginx
```

Try to reach nginx by `CLUSTER-IP` of the type `LoadBalancer` from `service/cilium-gateway-my-gateway` 

    $ curl 10.152.183.103:80

To gain access from outside of the cluster, the Gateway needs an 
external IP address which will be provided with the load balancer.

    $ sudo k8s enable load-balancer

Link to a CIDR Calculator: https://account.arin.net/public/cidrCalculator

Configure the load balancer CIDR. Choose an appropriate value depending on your cluster. 
This will assign an external IP to cilium-gateway-my-gateway.

The IP address for should then be 10.3.1.230

    $ sudo k8s set load-balancer.cidrs=10.3.1.230/32 load-balancer.l2-mode=true