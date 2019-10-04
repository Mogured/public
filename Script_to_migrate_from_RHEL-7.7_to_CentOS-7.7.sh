#!/bin/bash

echo "----------------------------------------------------------------"
echo "##Checking the currently installed version/release##"
echo "----------------------------------------------------------------"
cat /etc/*release
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Checking which RHEL-related packages are installed##"
echo "----------------------------------------------------------------"
rpm -qa|egrep "rhn|redhat"
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Removing some of the above packages and dependencies with yum##"
echo "----------------------------------------------------------------"
yum remove rhnlib redhat-support-tool redhat-support-lib-python redhat-upgrade-dracut-plymouth redhat-upgrade-dracut
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Manually uninstalling the rest to not have issues with dependencies##"
echo "----------------------------------------------------------------"
rpm -e --nodeps redhat-release-server
rpm -e --nodeps redhat-logos
rpm -e --nodeps yum
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##After these steps, verify if everything has been removed##"
echo "----------------------------------------------------------------"
rpm -qa|egrep -i "rhn|redhat"
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Deleting some folders to prevent problems with messages cpio##"
echo "----------------------------------------------------------------"
rm -rf /usr/share/doc/redhat-release/
rm -rf /usr/share/redhat-release/
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Downloading the CentOS GPG-key and package replacements for the previously removed packages##"
echo "----------------------------------------------------------------"
mkdir tmp
cd tmp
curl -O  http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
curl -O  http://mirror.centos.org/centos/7/os/x86_64/Packages/yum-3.4.3-163.el7.centos.noarch.rpm
curl -O  http://mirror.centos.org/centos/7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-52.el7.noarch.rpm
curl -O  http://mirror.centos.org/centos/7/os/x86_64/Packages/centos-logos-70.0.6-3.el7.centos.noarch.rpm
curl -O  http://mirror.centos.org/centos/7/os/x86_64/Packages/centos-release-7-7.1908.0.el7.centos.x86_64.rpm
chmod 755 RPM*
chmod 755 yum*
chmod 755 centos*
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Installing the GPG-key##"
echo "----------------------------------------------------------------"
rpm --import RPM-GPG-KEY-CentOS-7
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Installing the download packages##"
echo "----------------------------------------------------------------"
rpm -Uvh *.rpm
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##unregister and removing Subscription manager for RedHat"
echo 
subscription-manager clean
subscription-manager remove --all
subscription-manager unregister
locate subscription-manager
rpm -e --nodeps subscription-manager
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Putting yum in a clean, updated state##"
echo "----------------------------------------------------------------"
yum clean all
yum upgrade
echo "----------------------------------------------------------------"
echo "Press intro to continue..."
read intro

echo "##Updating the GRUB2-config to include the new information##"
echo "----------------------------------------------------------------"
grub2-mkconfig -o /boot/grub2/grub.cfg
echo "----------------------------------------------------------------"

echo "##press intro to continue and reboot the system##"
read intro
sudo init 6