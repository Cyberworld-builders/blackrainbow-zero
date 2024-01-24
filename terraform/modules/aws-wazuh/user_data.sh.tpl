#!/usr/bin/env bash

echo "Downloading Wazuh certificates tool" >> /tmp/initlog
curl -sO https://packages.wazuh.com/4.7/wazuh-certs-tool.sh | tee -a /tmp/initlog
curl -sO https://packages.wazuh.com/4.7/config.yml | tee -a /tmp/initlog

echo "Creating Wazuh certificates" >> /tmp/initlog
touch /tmp/config.yml | tee -a /tmp/initlog

cat << EOF | sudo tee /tmp/config.yml
nodes:
  # Wazuh indexer nodes
  indexer:
    - name: node-1
      ip: "${eip}"

  # Wazuh server nodes
  # If there is more than one Wazuh server
  # node, each one must have a node_type
  server:
    - name: wazuh-1
      ip: "${eip}"

  # Wazuh dashboard nodes
  dashboard:
    - name: dashboard
      ip: "${eip}"
EOF

sudo chmod +x wazuh-certs-tool.sh
bash ./wazuh-certs-tool.sh -A | tee -a /tmp/initlog
tar -cvf ./wazuh-certificates.tar -C ./wazuh-certificates/ .
rm -rf ./wazuh-certificates

echo "Installing Wazuh" >> /tmp/initlog
apt-get install debconf adduser procps | tee -a /tmp/initlog
apt-get install gnupg apt-transport-https | tee -a /tmp/initlog
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update

echo "Installing Wazuh Manager" >> /tmp/initlog
apt-get -y install wazuh-indexer | tee -a /tmp/initlog

echo "Done." >> /tmp/initlog
