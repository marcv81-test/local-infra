# Resources setup

Download the Ubuntu image.

    IMAGE=eoan-server-cloudimg-amd64.img
    wget -O resources/images/${IMAGE} https://cloud-images.ubuntu.com/eoan/current/${IMAGE}

Generate the SSH key.

    ssh-keygen -t ed25519 -f resources/keys/id_ubuntu -N '' -C 'ubuntu'

# Usage

## Packer

Set up virtualenv.

    virtualenv -p python3
    source venv/bin/activate
    pip3 install -r requirements.txt

Create the base image.

    python3 packer/wrapper.py

## Terraform

Terraform the environment.

    cd terraform/env
    terraform init
    terraform apply

SSH into the server.

    ssh ubuntu@$(terraform output server_ip_address) \
      -i ../../resources/keys/id_ubuntu \
      -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile /dev/null"
