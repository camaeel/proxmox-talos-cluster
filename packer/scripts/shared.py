import os
from proxmoxer import ProxmoxAPI


def setup_proxmox(proxmox_host):
  proxmox_user,proxmox_token_name = os.environ.get('PROXMOX_USERNAME').split('!')
  proxmox_token = os.environ.get('PROXMOX_TOKEN')
  pve = ProxmoxAPI(proxmox_host, user = proxmox_user, token_name = proxmox_token_name, token_value=proxmox_token, verify_ssl=True)
  # pve = ProxmoxAPI(proxmox_host, user='kamil',  sudo=True, backend='ssh_paramiko') #doesn't work
  return pve