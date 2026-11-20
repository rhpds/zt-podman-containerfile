#!/bin/bash

# Pull the images ahead of time
podman pull registry.access.redhat.com/ubi10/ubi
podman pull registry.access.redhat.com/ubi10/ubi-init
podman pull registry.access.redhat.com/hi/httpd

# Stage the working directory for the lab user.
# The Containerfile itself is authored by the learner in module-01.
mkdir -p /home/rhel/my-container/app
cat << EOF > /home/rhel/my-container/app/index.html
<HTML>
<HEAD>
<TITLE>My Web App</TITLE>
</HEAD>
This is my web app
</HTML>
EOF
chown -R rhel:rhel /home/rhel/my-container
