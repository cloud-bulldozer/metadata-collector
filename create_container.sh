#!/bin/bash
set -ex

## Clone stockpile
sudo rm -rf stockpile
git clone https://github.com/redhat-performance/stockpile.git

cp Dockerfile stockpile/
cp group_vars.yml stockpile/group_vars/all.yml
cp stockpile_hosts stockpile/hosts
cp ansible.cfg stockpile/ansible.cfg
if [ `ls -A roles`  ]
then
  cp -r roles/* stockpile/roles
fi

#This should really be changed in upstream stockpile to add tags to each role so we can pick what we want to run
cp stockpile_roles.yml stockpile/stockpile.yml

cd stockpile

# Modify this to whatever image repo to use
sudo docker build --tag=quay.io/dry923/backpack:stockpile . && sudo docker push quay.io/dry923/backpack:stockpile
