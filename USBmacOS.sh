#!/bin/bash
BDF=0000:XX:XX.X

./driverctl/driverctl --nosave set-override $BDF vfio-pci
./basic.sh
./driverctl/driverctl --nosave unset-override $BDF
