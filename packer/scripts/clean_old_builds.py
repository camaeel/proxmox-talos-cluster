#!/usr/local/bin/python3

import shared
import sys
import re

def usage():
  print("clean_old_builds.py proxmox_host tags [number_of_builds_to_keep]")
  print("    proxmox_host - host to connect to")
  print("    node - proxmox cluster node")
  print("    tags - comma separated list of tags")
  print("    number_of_builds_to_keep - number of most recent builds to keep per proxmox node. By default 1. -1 means dry run")

def find_vms_by_tags(node, tags):
  tags_splited = tags.split(',')
  res = []
  for vm in node.qemu.get():
    vmtags = re.split('[,;]',vm.get('tags',''))
    if set(vmtags).issuperset(set(tags_splited)):
      res.append(vm)

  return res

def compare_criteria(vm):
  return vm["name"].split('.')[-1]

def sort_by_timestamp(vms):
  vms.sort(key=compare_criteria, reverse = True)
  return vms

def delete_old_vms(node, vms_sorted, build_to_keep, dry_run):
  builds_to_keep_internal = build_to_keep
  if dry_run:
    builds_to_keep_internal = 0
  for vm in vms_sorted[builds_to_keep_internal:]:
    if not dry_run :
      node.qemu(vm['vmid']).delete(**{"purge": 1, "destroy-unreferenced-disks": 1} )
      print(f"Deleted vm {vm['vmid']} from node {node}")
    else: print(f"DRY RUN: Deleted vm {vm['vmid']}")

def main():
  if len(sys.argv) != 5 and len(sys.argv) != 4:
      print("Wrong number of arguments")
      usage()
      sys.exit(1)
  if len(sys.argv) == 4:
    builds_to_keep = 1
  else:
    builds_to_keep = int(sys.argv[4])

  node_name = sys.argv[2]
  tags = sys.argv[3]
  proxmox_host = sys.argv[1]
  dry_run = (builds_to_keep <0 )

  print(f"Running cleanup script for node={node_name}, tags={tags}, builds_to_keep={builds_to_keep}")

  pve = shared.setup_proxmox(proxmox_host)
  node = pve.nodes(node_name)

  vms = find_vms_by_tags(node, tags)
  vms_sorted = sort_by_timestamp(vms)

  delete_old_vms(node, vms_sorted, builds_to_keep, dry_run)

if __name__ == "__main__":
    main()
