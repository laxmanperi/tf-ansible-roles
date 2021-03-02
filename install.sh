#!/bin/bash
sudo yum -y install epel-release
sudo yum -y install ansible
sudo yum -y install git
sudo yum -y install unzip
sudo yum -y install vim
sudo git clone https://github.com/laxmanperi/tf-ansible-roles.git
sudo chown -R centos:centos tf-ansible-roles