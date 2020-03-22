#!/usr/bin/env python3

import argparse
import json
import os
import shutil

project_dir = os.path.realpath(os.path.dirname(__file__) + '/..')

# Parses the command line arguments.
parser = argparse.ArgumentParser(description=
    'Snapshots the provisioning VMs disks. The VMs should not run.')
parser.add_argument('--filter', default='', help='disk name prefix')
arguments = parser.parse_args()

# Lists the disks attached to the provisioning VMs.
def list_disks():
    state = '%s/terraform/environments/provision/terraform.tfstate' % project_dir
    with open(state) as stream:
        data = json.load(stream)
    for resource in data['resources']:
        if resource['type'] != 'libvirt_domain': continue
        for instance in resource['instances']:
            for disk in instance['attributes']['disk']:
                yield disk['volume_id']

# Copies the disks attached to the provisionning VMs.
for disk in list_disks():
    name = os.path.basename(disk)
    if not name.startswith(arguments.filter): continue
    shutil.copy(disk, '%s/resources/images/%s' % (project_dir, name))
    print('Snapshotted %s' % name)
