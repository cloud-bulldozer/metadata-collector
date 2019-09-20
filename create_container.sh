#!/bin/bash
set -ex

## Clone stockpile
sudo rm -rf stockpile
git clone https://github.com/redhat-performance/stockpile.git

## Clone snafu and copy in wrapper
sudo rm -rf snafu

## FIX THIS TO BE UPSTREAM SNAFU ONCE MERGED
git clone --branch backpack https://github.com/dry923/snafu.git

## Clone scribe and copy into stockpile
sudo rm -rf scribe

#git clone https://github.com/redhat-performance/scribe.git
git clone https://github.com/dry923/scribe.git --branch cpuinfo

cp Dockerfile stockpile/
cp group_vars.yml stockpile/group_vars/all.yml
cp stockpile_hosts stockpile/hosts
cp ansible.cfg stockpile/ansible.cfg
if [ `ls -A roles`  ]
then
  cp -r roles/* stockpile/roles
fi

#This should really be changed in upstream stockpile to add tags to each role so we can pick what we want to run
#cp stockpile_roles.yml stockpile/stockpile.yml

## Copy snafu wrapper into stockpile
cp snafu/backpack-wrapper/backpack-wrapper.py stockpile/backpack-wrapper.py

cp -r scribe stockpile/

cd stockpile

# Modify this to whatever image repo to use
sudo docker build --tag=quay.io/dry923/backpack:stockpile_test . && sudo docker push quay.io/dry923/backpack:stockpile_test
