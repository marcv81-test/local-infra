# Usage

## Resources

Generate the SSH key.

    ssh-keygen -t ed25519 -f resources/keys/id_ubuntu -N '' -C 'ubuntu'

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
