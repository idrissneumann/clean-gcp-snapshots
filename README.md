# Cleaning GCP snapshots of VMs


This script can be used to clean old snapshots. Sometimes it's usefull if you don't have set a retention policy and you have to wait before applying a new one (using terraform or whatever).

Beware: keep only one snapshot per disk!

## Table of content

[[_TOC_]]

## Git repositories

* Main repo: https://gitlab.comwork.io/oss/clean-gcp-snapshots
* Github mirror: https://github.com/idrissneumann/clean-gcp-snapshots.git
* Gitlab mirror: https://gitlab.com/ineumann/clean-gcp-snapshots.git
* Bitbucket mirror: https://bitbucket.org/idrissneumann/clean-gcp-snapshots

## Getting started

You can run it like that:

```shell
./clean_snapshots_gcp.sh -e <environment> -p <product> -c
./clean_snapshots_gcp.sh -e sandbox -p eventstore -c
```

In order to know more about the available options, you can run:

```shell
./clean_snapshots_gcp.sh -h
```

You can also pass args as variable if you don't want to set all parameters:

```shell
P_LIMIT=1000 P_ENV=sandbox P_NAME=eventstore ./clean_snapshots_gcp.sh -c
```
