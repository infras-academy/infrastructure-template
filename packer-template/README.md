# Requirements:
VAULT_ADDR=
VAULT_TOKEN=


# Command:

```bash
cd infrastructure-template/packer-template/ubuntu-20.04-base-template
packer build -var-file=auto.pkrvars.hcl .
```

# Overview

## Jenkins Controller:
- Installed plugins:
- Skip init
- Default admin credential (need to change it manually)

## Ubuntu base 20.04:
- Plain ubuntu server 20.04, no additional packages

