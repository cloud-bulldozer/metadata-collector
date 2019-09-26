#!/bin/bash
set -ex

## Clone stockpile
sudo rm -rf stockpile
#git clone https://github.com/redhat-performance/stockpile.git
git clone https://github.com/dry923/stockpile.git --branch container

cp Dockerfile stockpile/
cp group_vars.yml stockpile/group_vars/all.yml
cp stockpile_hosts stockpile/hosts
cp ansible.cfg stockpile/ansible.cfg

cd stockpile

# Modify this to whatever image repo to use
sudo docker build --tag=quay.io/cloud-bulldozer/backpack:master . && sudo docker push quay.io/cloud-bulldozer/backpack:master
