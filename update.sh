#!/bin/bash

if [ -f "$1" ] ;
then 
tar -C .. -zxf $1

vagrant halt
vagrant destroy
for i in `vagrant box list | grep GreenSocsBaseMachine`; do vagrant box remove $i; done
rm -rf ModelLibrary

vagrant up

else
echo "Usage ./update.sh <tarball>"
fi
