#!/usr/bin/env bash

set -e

CLI_VERSION=`talosctl  version --short --client | egrep "Client v(.*)$" | sed  's/Client v//'`

echo "CLI_VERSION=${CLI_VERSION}"

TALOSCTL_CONTEXT=`talosctl  config info -o json | jq -r '.context'`
TALOSCTL_SHORT_NAME=`echo $TALOSCTL_CONTEXT | sed 's/^talos-//'`

SCHEMATIC=`terragrunt --terragrunt-working-dir "$HOME/~/src/github.com/home-lab-talos/terragrunt2/${TALOSCTL_SHORT_NAME}/talos-cluster" output -raw image_factory_schematic` #TODO update path here
TARGET_IMAGE="factory.talos.dev/installer/${SCHEMATIC}:${CLI_VERSION}"

NODES=`talosctl get  nodename  -o json | jq -r '.node'`
echo "Nodes versions:"
for NODE in $NODES; do
  VERSION=`talosctl -n $NODE version  --short | egrep 'Tag:\s*v(.*)$' | sed -E 's/^[[:space:]]+Tag:[[:space:]]+v//'`
  echo "$NODE [$VERSION]"
  if [[ "$VERSION" != "$CLI_VERSION" ]]; then
    echo "Version doesn't match with cli, upgrading..."
    talosctl -n $NODE upgrade --image ${TARGET_IMAGE}
  fi
done
