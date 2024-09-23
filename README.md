# proxmox-talos-cluster
This repository provides terraform modules for setting up Talos (https://www.talos.dev) Kubernetes cluster running on Proxmox

## Prerequisites

* talosctl - can be installed with `scripts/upgrade-cli.sh`
* jq
* terraform
* terragrunt (optional)

## Project elements

### Packer

`packer` directory contains packer setup used for building Proxmox VM templates from talos disk image. It also automatically cleans up previous builds.

#### Setup 

Create `packer/.env` script based on `packer/.env-template` to provide proxmox token in a easy way. 
Template script exports username & token using SSH access to proxmox. This may be not possible for every setup. 
Use secure source of credentials like Hashicrop Vault, AWS SSM parameters or OS keychain.
