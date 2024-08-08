# Repository structure
.
└── .env
└── .sops.yaml

# Private key generation
```
age-keygen >> ~/.config/sops/age/keys.txt
```
* Note: multiple private/public keypairs can be stored in this file
* SOPS will automatically match the correct private key based on .sops.yaml
