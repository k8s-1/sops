# Process

```
kubectl create secret generic test --from-literal key=123 $dry > secret.enc.yaml

sops -e -i secret.enc.yaml

cue import secret.enc.yaml # outputs secret.enc.cue
```
