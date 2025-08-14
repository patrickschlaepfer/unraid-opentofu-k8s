# kubernetes-gateway-api

## Links

- https://kubito.dev/posts/gateway-api-setup-cilium-load-balancing/

## CiliumLoadBalancerIPPool

Show all CiliumLoadBalancerIPPool

    $ kubectl get CiliumLoadBalancerIPPool -A

Delete a CiliumLoadBalancerIPPool

    $ kubectl delete CiliumLoadBalancerIPPool example-ip-pool

## CiliumL2AnnouncementPolicy

Show all CiliumL2AnnouncementPolicy

    $ kubectl get CiliumL2AnnouncementPolicy -A

Delete

    $ kubectl delete CiliumL2AnnouncementPolicy example-l2advertisement-policy