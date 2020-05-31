#!/bin/bash

BIND_PID1="XXXX XXXX" # There should not be ":" in the middle. Only space
BIND_BDF1="0000:XX:XX.X"

modprobe vfio-pci
echo "$BIND_PID1" > /sys/bus/pci/drivers/vfio-pci/new_id
echo "$BIND_BDF1" > /sys/bus/pci/devices/$BIND_BDF1/driver/unbind
echo "$BIND_BDF1" > /sys/bus/pci/drivers/vfio-pci/bind
echo "$BIND_PID1" > /sys/bus/pci/drivers/vfio-pci/remove_id
