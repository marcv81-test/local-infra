# Usage

## Resources

Generate the SSH key.

    ssh-keygen -t ed25519 -f resources/keys/id_ubuntu -N '' -C 'ubuntu'

Download the Ubuntu image.

    wget -O resources/images/eoan-server.img https://cloud-images.ubuntu.com/eoan/current/eoan-server-cloudimg-amd64.img

Increase the Ubuntu image size.

    cp resources/images/eoan-server.img resources/images/eoan-server-5g.img
    qemu-img resize resources/images/eoan-server-5g.img 5G


Create an empty disk image.

    qemu-img create -f qcow2 resources/images/empty-10g.img 10G
    virt-format -a resources/images/empty-10g.img --partition=gpt --filesystem=ext4

## Provisioning

Create the provisioning environment.

    cd terraform/environments/provision
    terraform init
    terraform apply

Update the system resolver.

    sudo ./scripts/update_resolver.py

Provision the environment with Ansible.

    cd ansible
    virtualenv -p python3 venv
    source venv/bin/activate
    pip3 install -r requirements.txt
    ansible-playbook -i hosts.yml provision.yml

Snapshot the disks.

    virsh shutdown server-01.provision
    virsh shutdown server-02.provision
    ./scripts/snapshot_disks.py

Destroy the environment.

    cd terraform/environments/provision
    terraform destroy

## Test environment

Terraform the environment.

    cd terraform/environments/test
    terraform init
    terraform apply

Update the system resolver.

    sudo ./scripts/update_resolver.py
