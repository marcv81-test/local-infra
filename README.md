# Usage

## Resources

Generate the SSH key.

    ssh-keygen -t ed25519 -f resources/keys/id_ubuntu -N '' -C 'ubuntu'

Download the Ubuntu image.

    wget -O resources/images/eoan-server.img https://cloud-images.ubuntu.com/eoan/current/eoan-server-cloudimg-amd64.img

Create an empty disk image.

    qemu-img create -f qcow2 resources/images/empty.img 10G
    virt-format -a resources/images/empty.img --partition=gpt --filesystem=ext4

## Terraform

Terraform the test environment.

    cd terraform/environments/test
    terraform init
    terraform apply
