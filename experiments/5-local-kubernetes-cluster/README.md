# Local Kubernetes cluster

Automate building local kubernetes clusters for testings.

## Prerequisites

- [Terraform kubernetes module](https://github.com/jetthoughts/infrastructure/tree/master/modules)


## Step 1 - Masters

Create terraform rescources to build node and ssh keys

Verify:

A new ssh key would be generated in `assets/private.key`
Linux would setup user `admin` to allow access from ssh.

```shell
$ ssh "admin@$(terraform output master_addresses)" -i ./assets/private.key
```

## Step 2 - Nodes
