#!/usr/bin/bash

check() {
  return 0
}

install() {
  inst_hook pre-udev 00 "${moddir}/vfio-pci-override.sh"  
}
