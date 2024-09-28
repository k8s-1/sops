# This is a testing repo. The encrypted "secrets" here are of no significance.

# SOPS setup (Secret OPerationS)
* Requires flux cluster

## Install packages
* gnupg
* sops

## Generate GPG key without passphrase
```
export KEY_NAME="cluster0.yourdomain.com"
export KEY_COMMENT="flux secrets"

gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Comment: ${KEY_COMMENT}
Name-Real: ${KEY_NAME}
EOF
```
The above configuration creates an rsa4096 key that does not expire.

## Retrieve GPG fingerprint
* The key fingerprint points to the actual rs4096 key
```
gpg --list-secret-keys "${KEY_NAME}"

sec   rsa4096 2020-09-06 [SC]
      1F3D1CED2F865F5E59CA564553241F147E7C5FA4
```

## Export GPG fingerprint to env
```
export KEY_FP=1F3D1CED2F865F5E59CA564553241F147E7C5FA4
```

## Export public and private keypair from local GPG keyring and create k8s secret sops-gpg in flux-system namespace
* --armor makes the private key readable in text
```
gpg --export-secret-keys --armor "${KEY_FP}" |
kubectl create secret generic sops-gpg \
--namespace=flux-system \
--from-file=sops.asc=/dev/stdin
```

* Back this key/secret up with secret manager
* Delete decryption key to be safe

```
gpg --delete-secret-keys "${KEY_FP}"
```

## Register resources in flux cluster

### Git repo
```
flux create source git my-secrets \
--url=https://github.com/my-org/my-secrets \
--branch=main
```

### Kustomization for secret
```
flux create kustomization my-secrets \
--source=my-secrets \
--path=./clusters/cluster0 \
--prune=true \
--interval=10m \
--decryption-provider=sops \
--decryption-secret=sops-gpg
```
* NOTE: sops-gpg can contain more than one key, sops will try to decrypt by iterating over private keys

## (OPTIONAL) Export public key to git directory so team members can encrypt files
```
gpg --export --armor "${KEY_FP}" > ./clusters/cluster0/.sops.pub.asc
```

### Check file contents to ensure its the public (not private!) key
```
git add ./clusters/cluster0/.sops.pub.asc
git commit -am 'Share GPG public key for secrets generation'
```

### Team members can now import the key after git cloning
```
gpg --import ./clusters/cluster0/.sops.pub.asc
```

* The public key is sufficient for creating brand new files.
* The secret key is required for decrypting and editing existing files because SOPS computes a MAC on all values.
* When using solely the public key to add or remove a field, the whole file should be deleted and recreated.

# Configure the git directory for encryption
```
cat <<EOF > ./clusters/cluster0/.sops.yaml
creation_rules:
  - path_regex: .*.yaml
    encrypted_regex: ^(data|stringData)$
    pgp: ${KEY_FP}
EOF
```

* This config applies recursively to all sub-directories.
* Multiple directories can use separate SOPS configs.
* Contributors using the sops CLI to create and encrypt files won’t have to worry about specifying the proper key for the target cluster or namespace.
* encrypted_regex helps encrypt the data and stringData fields for Secrets. (other fields e.g. kind or apiVersion is not supported by kustomize-controller)


# Encryption with OpenPGP

## Generate secret manifest
```
kubectl -n default create secret generic basic-auth \
--from-literal=user=admin \
--from-literal=password=change-me \
--dry-run=client \
-o yaml > basic-auth.yaml
```

## Encrypt with sops
```
sops --encrypt --in-place basic-auth.yaml
```
* Now you can git commit the secret

# Encryption with age (RECOMMENDED)
* Simple, modern alternative to openPGP

## Generate a key
```
age-keygen -o age.agekey
```
* Remember to backup the age.agekey file to a secure secret store. If you need to recreate your clusters you need to have the private key available to be able to decrypt your secrets again.

## Generate secret manifest
```
cat age.agekey |
kubectl create secret generic sops-age \
--namespace=flux-system \
--from-file=age.agekey=/dev/stdin
```

## Encrypt with sops
```
sops --age=age1helqcqsh9464r8chnwc2fzj8uv7vr5ntnsft0tn45v2xtz0hpfwq98cmsg \
--encrypt --encrypted-regex '^(data|stringData)$' --in-place basic-auth.yaml
```

## Decrypt
```
export SOPS_AGE_KEY_FILE=$(pwd)/age.agekey
sops -d file.enc
```

# Other SOPS encryption methods
https://fluxcd.io/flux/guides/mozilla-sops/
* Various cloud providers e.g. Azure vault
* Hashicorp vault
