#!/bin/sh

ip=$1
password=$2

# install shadowsocks by pip
apt-get update
apt-get install python-pip
apt-get install python-setuptools
pip install shadowsocks

# create config file
echo "{\"server\":\"$1\", \"server_port\":8388, \"local_address\": \"127.0.0.1\", \"local_port\":1080, \"password\":\"$2\",	\"timeout\":300, \"method\":\"aes-256-cfb\"}" > /etc/shadowsocks.json

# fix EVP_CIPHER_CTX_cleanup no found
sed -i s/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py

# start service
ssserver -c /etc/shadowsocks.json -d start
