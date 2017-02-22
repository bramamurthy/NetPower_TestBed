#!/bin/bash

echo "#############################################################################"
echo "Installing python packages"
echo "#############################################################################"

sudo apt-get -y install python-pip
sudo apt-get -y install python-httplib2
sudo pip install ryu==4.0
sudo pip install numpy
sudo pip install pypcapfile
sudo pip install dpkt
sudo pip install six
sudo pip install networkx

echo "#############################################################################"
echo "Setting up mininet"
echo "#############################################################################"

sudo apt-get -y install openssh-server
sudo apt-get -y install expect
sudo ufw disable
sudo apt-get -y install mininet

echo "#############################################################################"
echo "Setting up NetPower"
echo "#############################################################################"


pushd src/core/libs
sudo python setup.py build_ext --inplace
popd


echo "#############################################################################"
echo "Building openvswitch"
echo "#############################################################################"

sudo apt-get -y purge openvswitch-common

pushd ~/Downloads

wget http://openvswitch.org/releases/openvswitch-2.3.0.tar.gz
tar -xzvf openvswitch-2.3.0.tar.gz
pushd openvswitch-2.3.0
sudo ./configure
sudo make
sudo make install
sudo make modules_install
sudo /sbin/modprobe openvswitch
popd
popd

echo "#############################################################################"
echo "Setting up openvswitch"
echo "#############################################################################"

sudo cp -v start-ovs.sh ~/Downloads/openvswitch-2.3.0/
sudo chmod +x ~/Downloads/openvswitch-2.3.0/start-ovs.sh
sudo cp -v start_ovs.sh /etc/init.d/
sudo chmod +x /etc/init.d/start_ovs.sh
sudo update-rc.d start_ovs.sh defaults


echo "#############################################################################"
echo "Setting up TimeKeeper"
echo "#############################################################################"

sudo ln -s $HOME/Desktop/TimeKeeper/dilation-code $HOME/NetPower_TestBed/src/core/dilation-code