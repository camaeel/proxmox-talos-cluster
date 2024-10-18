#!/bin/bash

if [[ -f .env ]] ; then
  source .env
fi

set -e

packer init .

python3 -m venv .venv
source .venv/bin/activate
pip3 install -r scripts/requirements.txt

packer validate -evaluate-datasources .

packer build  $@ .

