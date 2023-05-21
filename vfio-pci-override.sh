#!/usr/bin/bash

# ...
shopt -s lastpipe

# Usage: log <message>
# Log a message.
log() {
  if [[ "${LOG}" -ge 1 ]]; then
    printf "%s\n" "${1}"
  fi
}

# Usage: warning <message>
# Log a warning.
warning() {
  if [[ "${LOG}" -ge 2 ]]; then
    printf "\e[33m%s\e[m\n" "${1}"
  fi
}

# Usage: error <message>
# Log an error.
error() {
  if [[ "${LOG}" -ge 3 ]]; then
    printf "\e[31m%s\e[m\n" "${1}"
  fi
}

# ...
cat /proc/cmdline \
  | IFS=' ' read -a kernel_parameters

log 'Kernel parameters found'
log "Kernel parameters: ${kernel_parameters[*]}"

# ...
for parameter in "${kernel_parameters[@]}"; do
  if [[ "${parameter}" =~ vfio-pci-devices=* ]]; then
    printf "${parameter:17}" \
      | IFS=',' read -a vfio_pci_devices

    log 'vfio-pci-devices kernel parameter found'
    log "vfio-pci-devices: ${vfio_pci_devices[*]}"
    break
  else
    warning 'vfio-pci-devices kernel parameter not found'
  fi
done

# ...
if [[ -v vfio_pci_devices ]]; then
  log 'vfio_pci_devices environment variable found'
  log "vfio_pci_devices: ${vfio_pci_devices[*]}"
  
  for device in "${vfio_pci_devices[@]}"; do
    printf vfio-pci > "/sys/bus/pci/devices/${device}/driver_override"
  done
else
  warning 'vfio_pci_devices environment variable not found'
fi
