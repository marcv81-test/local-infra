#!/usr/bin/env python3

import fcntl
import os
import socket
import struct
import subprocess

# Returns the IPv4 address of an interface, or raises an OSError.
def get_ip_address(interface_name):
    SIOCGIFADDR = 0x8915
    argument = bytearray(struct.pack('40s', bytes(interface_name[:16], 'utf-8')))
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        fcntl.ioctl(s.fileno(), SIOCGIFADDR, argument)
    return socket.inet_ntoa(argument[20:24])

# Parses a libvirt network configuration file.
# Returns the domain and the interface, or raises a KeyError.
def parse_network_config(filename):
    keys = 'domain', 'interface'
    values = {}
    with open(filename) as stream:
        for line in stream:
            for key in keys:
                if not line.startswith(key + '='): continue
                value = line.strip()[len(key)+1:]
                values[key] = value
    return [values[key] for key in keys]

# Iterates over the well-configured libvirt networks.
# Yields the domain name, the interface name, and the DNS server IP address.
def get_networks():
    dirname = '/var/lib/libvirt/dnsmasq'
    for filename in os.listdir(dirname):
        if not filename.endswith('.conf'): continue
        filename = dirname + '/' + filename
        try: domain, interface = parse_network_config(filename)
        except KeyError: continue
        try: ip_address = get_ip_address(interface)
        except OSError: continue
        yield domain, interface, ip_address

# Updates systemd-resolved for the well-configured libvirt networks.
for domain, interface, ip_address in get_networks():
    command = ['systemd-resolve',
        '--interface', interface,
        '--set-dns', ip_address,
        '--set-domain', domain]
    subprocess.check_call(command)
    print('Configured "%s" (%s, %s)' % (domain, interface, ip_address))
