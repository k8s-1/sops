# Process

### 1. Create secret
```
kubectl create secret generic test --from-literal key=123 $dry > secret.enc.yaml
```

### 2. Encrypt with sops
```
sops -e -i secret.enc.yaml
```

### 3. Import to cue
```
cue import secret.enc.yaml # outputs secret.enc.cue
```

### 4. Export as needed

### 5. Decrypt
```
export SOPS_AGE_KEY_FILE=$(pwd)/age.agekey
sops <key>
```
