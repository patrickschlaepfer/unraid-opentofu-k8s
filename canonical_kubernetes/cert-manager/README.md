# cert-manager

In order to get the wildcard certificate I use zerossl
and Amazon Route53.

## Route53

- https://cert-manager.io/docs/configuration/acme/dns01/route53/
- https://cert-manager.io/docs/tutorials/zerossl/zerossl/

### IAM Policy

Create a user in Amazon and assign the following policiy.

Get then the API User and key, which then is be used by the certificate generation.

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/*",
      "Condition": {
        "ForAllValues:StringEquals": {
          "route53:ChangeResourceRecordSetsRecordTypes": ["TXT"]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}
```

## Install 

```
helm upgrade --install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.18.2 \
  --namespace cert-manager \
  --create-namespace \
  -f values.yaml
```

## Restart

    $ kubectl rollout restart deployment cert-manager -n cert-manager

### Troubleshooting

If something is wrong in your configuration, like wrong API User in the `ClusterIssuer``
resource, you have to recreate it.

Get the actual configuration 

    $ kubectl describe clusterissuer

If there are old references, delete the whole resource, and reapply it.

    $ kubectl delete clusterissuer <CLUSTERISSUER_NAME>
    $ kubectl apply -f zerossl-production.yaml

And if there are certificaterequest delete them

    $ kubectl get certificaterequest -A
    $ kubectl delete certificaterequest <REQUEST-NAME> -n common