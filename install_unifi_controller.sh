#!/bin/sh

#Install the UniFi controller software on Ubuntu/Debian System.
#Updated 28 March 2019
#By David Wyman
#Content has been taken from several sources, Crosstalk Solutions and Steve Jenkins.

clear
#Check that URL has been specified at commandline.
if [ ! "$1" ]; then
	echo "No UniFi URL specified."
	echo "e.g. install.sh unifi.example.com"
exit 1
fi

#Install random number generator for Linux (speeds up launching UniFi)
sudo apt-get install haveged -y

#Install Java 8
#Add an apt source for Java 8
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list 
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list 

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 
sudo apt-get update 
sudo apt-get install oracle-java8-installer

#Install UniFi
#Add an apt source for UniFi
echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list

sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ubnt.com/unifi/unifi-repo.gpg

#Install UniFi
sudo apt-get update
sudo apt-get install unifi -y

#Install Certbot
#Add an apt source for Certbot
sudo add-apt-repository ppa:certbot/certbot

sudo apt-get update
sudo apt-get install python-certbot-apache -y

#Generate our SSL certificate
sudo certbot --apache -d $1

sudo wget https://github.com/houdini2nd/unifi/unifi_ssl_import.sh -O /usr/local/bin/unifi_ssl_import.sh
