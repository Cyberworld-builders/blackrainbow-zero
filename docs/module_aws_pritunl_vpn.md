# Deploying a Pritunl VPN on AWS

Reference the official docs [here](https://docs.pritunl.com/docs/repo). 

```bash
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt jammy main
EOF

sudo apt --assume-yes install gnupg
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
sudo apt update

# After-install setup (for some reason this fails during the userdata script)
sudo pritunl setup-key
sudo pritunl set-mongodb 'mongodb://localhost:27017/pritunl'

sudo pritunl default-password
```
## More Actions After Install to Get Started
- upgrade database
- reset password
- set mongodb
- set key
- set server

- create organization
- create user
- create server
- add organization to server

> You should now be able to download the client application, copy the user config from the dashboard, and then configure the client and connect. 

This is a simple deployment for a small implementation. It installs mongodb in the user_data script to run a local mongo service for a database. For larger-scale deployments you will want to run mongo as a separate service and cluster the pritunl server for horizontal scaling. That will also involve opening up a mongo port in the firewall and adjusting the role policies to allow interaction with MongoDB Atlas DocumentDB or wherever you choose to host your db.

That is not within the scope of this effort. 