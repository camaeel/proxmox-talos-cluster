#!/usr/bin/env bash

set -e

CLI_VERSION=`talosctl  version --short --client | egrep "Client v(.*)$" | sed  's/Client v//'`

echo "CLI_VERSION=${CLI_VERSION}"

NODES=`talosctl get  nodename  -o json | jq -r '.node'`
echo "Nodes versions:"
for NODE in $NODES; do
  VERSION=`talosctl -n $NODE version  --short | egrep 'Tag:\s*v(.*)$' | sed -E 's/^[[:space:]]+Tag:[[:space:]]+v//'`
  echo "$NODE [$VERSION]"
  if [[ "$VERSION" != "$CLI_VERSION" ]]; then
    echo "Version doesn't match with cli, upgrading..."
    talosctl -n $NODE upgrade
  fi
done
