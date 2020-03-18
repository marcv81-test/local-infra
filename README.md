# Usage

## Resources

Generate the SSH key.

    ssh-keygen -t ed25519 -f resources/keys/id_ubuntu -N '' -C 'ubuntu'

Create empty disk image.

    qemu-img create -f qcow2 resources/images/empty.img 10G
    virt-format -a resources/images/empty.img --partition=gpt --filesystem=ext4

## Packer

Set up virtualenv.

    virtualenv -p python3
    source venv/bin/activate
    pip3 install -r requirements.txt

Create the base image.

    python3 packer/wrapper.py

## Terraform

Terraform the environment.

    cd terraform/environments/test
    terraform init
    terraform apply
