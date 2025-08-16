# kubernetes-gateway-api

## Links

- https://kubito.dev/posts/gateway-api-setup-cilium-load-balancing/
- https://kubernetes.io/docs/concepts/services-networking/gateway/
- https://www.youtube.com/watch?v=RQbc_Yjb9ls


## Using cilium - metallb

Check for the gateway status. Gatway should be enabled by default.

    $ sudo k8s

Enable the load-balancer

    $ sudo k8s enable load-balancer

Calculate your cidr (https://account.arin.net/public/cidrCalculator) 
and then set it by the following command

    $ sudo k8s set load-balancer.cidrs=10.3.1.250/30 load-balancer.l2-mode=true


    $ kubectl -n kube-system rollout restart deployment/cilium-operator
    $ kubectl -n kube-system rollout restart ds/cilium

    $ kubectl -n kube-system rollout restart ds/cilium
    $ kubectl -n metallb-system rollout restart ds/metallb-speaker


