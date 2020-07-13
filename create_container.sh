#!/bin/bash
set -ex

## Clone stockpile
sudo rm -rf stockpile
git clone https://github.com/cloud-bulldozer/stockpile.git

sudo rm -f stockpile-wrapper.py
wget https://raw.githubusercontent.com/cloud-bulldozer/bohica/master/stockpile-wrapper/stockpile-wrapper.py

sudo rm -rf scribe
git clone https://github.com/cloud-bulldozer/scribe.git


# Get kubectl
sudo rm -f kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

cp Dockerfile stockpile/
cp all.yml stockpile/group_vars/all.yml
cp kubernetes.yml stockpile/group_vars/kubernetes.yml
cp stockpile_hosts stockpile/hosts
cp ansible.cfg stockpile/ansible.cfg
cp stockpile-wrapper.py stockpile/stockpile-wrapper.py
cp -r scribe stockpile/
cp kubectl stockpile/
cp oc stockpile/

cd stockpile

# Modify this to whatever image repo to use
sudo podman build --tag=quay.io/cloud-bulldozer/backpack:latest . && sudo podman push quay.io/cloud-bulldozer/backpack:latest
