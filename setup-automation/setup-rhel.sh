#!/bin/bash

# Unregister and register the VM
dnf -y remove katello-ca-consumer-*
subscription-manager clean
subscription-manager register --activationkey=$ACTIVATION_KEY --org=$ORG_ID --force

# Pull the images ahead of time
podman pull registry.access.redhat.com/ubi10/ubi
podman pull registry.access.redhat.com/ubi10/ubi-init

# Create the starting containerfile
mkdir -p ~/my-container/
cat << EOF >> ~/my-container/Containerfile
FROM registry.access.redhat.com/ubi10/ubi
RUN dnf -y install httpd
EXPOSE 80
CMD ["/usr/sbin/httpd","-DFOREGROUND"]
EOF

# moved from step 2 setup script
# Create the index.html
mkdir -p ~/my-container/app
cat << EOF >> ~/my-container/app/index.html
<HTML>
<HEAD>
<TITLE>My Web App</TITLE>
</HEAD>
This is my web app
</HTML>
EOF

