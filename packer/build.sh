#!/bin/bash

if [[ -f .env ]] ; then
  source .env
fi

set -e

packer init .

packer validate -evaluate-datasources .

packer build  $@ .

