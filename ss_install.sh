#!/bin/sh

net_dev=`ifconfig | head -n 1 | cut -d: -f 1`

ip=`ifconfig $net_dev | grep netmask | awk '{print $2}'`

if [ "$1" != "" ]; then
	pw=$1
else
	pw="defaultpasswd"
fi

echo [DEBUG]:net_dev=$net_dev ip=$ip pw=$pw

# install shadowsocks by pip
apt-get update
apt-get -y install python-pip
apt-get -y install python-setuptools
pip install wheel
pip install shadowsocks

# create config file
echo "{\"server\":\"$ip\", \"server_port\":443, \"local_address\": \"127.0.0.1\", \"local_port\":2080, \"password\":\"$pw\",	\"timeout\":300, \"method\":\"aes-256-cfb\"}" > /etc/shadowsocks.json

# fix EVP_CIPHER_CTX_cleanup no found
sed -i s/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py

# start service
ssserver -c /etc/shadowsocks.json -d start
