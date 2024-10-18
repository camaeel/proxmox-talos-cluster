#!/bin/bash

set -e

python3 -m venv ../.venv
source ../.venv/bin/activate
pip3 install -r requirements.txt

python3 clean_old_builds.py osiris.home.kamilk.eu osiris talos-base-image 5
