#!/usr/bin/env sh

set -e
export DEBIAN_FRONTEND=noninteractive

echo "${prefix}" > /etc/hostname
hostnamectl set-hostname "${prefix}"

echo "Installing Pritunl"
apt-get update

sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list << EOF
deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse
EOF

sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt jammy main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
curl https://raw/githubusercontent.com/pritunl/gpg/master/pritunl_repo_pub.asc | sudo apt-key add -

wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

apt-get update
apt-get install -y wireguard wireguard-tools

apt-get install -y pritunl mongodb-org
sudo systemctl start pritunl mongod
sudo systemctl enable pritunl mongod