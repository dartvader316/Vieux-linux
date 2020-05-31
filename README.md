Vieux on linux with QEMU + KVM
=======================

Requirements:
- Board with support for AMD-V or VT-x, as well as iommu (VT-d)
- QEMU 3.x or higher

You do not need any additional hardware, unless you don't have USB 2.0 ports or separate on-board controllers.

## Installing MacOS on QEMU + KVM

[To install MacOS in QEMU + KVM just follow the instruction here.](https://github.com/foxlet/macOS-Simple-KVM)

The only I can suggest is to install Mojave due most stable work with Vieux.

## Prepairing for USB passthrough

### Enable BIOS Features

Boot into your firmware settings, and turn on AMD-V/VT-x, as well as iommu (also called AMD-Vi, VT-d, or SR-IOV).

### Enable Kernel Features

The `iommu` kernel module is not enabled by default, but you can enable it on boot by passing the following flags to the kernel.

#### AMD
```
iommu=pt amd_iommu=on
```

#### Intel
```
iommu=pt intel_iommu=on
```

To do this permanently, you can add it to your bootloader. For example, if you are using GRUB, edit `/etc/default/grub` and add the previous lines to the `GRUB_CMDLINE_LINUX_DEFAULT` section, then run `sudo update-grub` (or `sudo grub-mkconfig` on some systems) and reboot.

## Getting IOMMU devices

`./lsiommu.sh` (included in this repo). 
If successful, you will get list of PCIe devices and their
IOMMU groups. If there is no output, double check BIOS settings.
To get only USB devices
`./lsiomu | grep -i USB`
As an example:

```
IOMMU Group 4 00:14.0 USB controller [0c03]: Intel Corporation 9 Series Chipset Family USB xHCI Controller [8086:8ca1]
```
Some groups contain more than one device. Look for an USB controller in its own group and note the
BDF ID (`00:14.0` in this example) and the PCI ID (`8086:8ca1` in this example).

## Installing driverctl

Move to your installed MacOS folder and run:

`git clone https://gitlab.com/driverctl/driverctl.git`

## Setting up launch script

Move `USBmacOS.sh` (included in this repo) to your installed MacOS folder, 

Open it with an editor and replace `BDF=0000:XX:XX.X` with BDF ID from earlier.

## Attaching USB's to MacOS

Add the following to the end of `basic.sh` and replace `host=XX:XX.X` with the BDF ID from earlier.

```
    -device pcie-root-port,bus=pcie.0,multifunction=on,port=1,chassis=1,id=port.1 \
    -device vfio-pci,host=XX:XX.X,bus=port.1 \
```

## Pre-running (Optional)

WARNING: If you have only one group of ports, after running MacOS all your USB devices may become unavailable in linux, and will only work in
MacOS inside QEMU. Because of no input your linux host's screen may go off and only reboot will help.
So I suggest to disable screen timeout in settings of your DE or to run these
commands:

### For X server:
`xset -dpms`

`xset s off`

If you shutdown from booted MacOS properly with QEMU exiting, usb ports will become normal.

## Runing MacOS

`sudo ./USBmacOS`. 

You should be able to connect your IOS device to the assigned ports and itunes must recognize your
device.
Then you can setup and run [Vieux](https://github.com/MatthewPierson/Vieux) there by its guide for MacOS

## Troubleshooting

```
Please ensure all devices within the iommu_group are bound to their vfio bus driver.
```
The USB controller you selected is in a group with more than one device, so add same group device's
BDF ID and PCI ID to `rebind.sh` (if there are more than 1 just clone rebind.sh file) and then run it (them):

`sudo ./rebind.sh` (included in this repo). 

or use an ACS patch (for advanced users).

```
iommu doesn't work properly when enabled in BIOS
```
Update your BIOS if possible, older boards may have issues with early implementations.

## Personally tested devices

- DISTRO: Arch linux, ipad air(WI-FI) IOS 12.0 -> IOS 10.3.3

## Thanks and sources

[downthecrop](https://github.com/downthecrop) for [passthrough USB guide](https://github.com/downthecrop/macOS-Simple-KVM)

[foxlet](https://github.com/foxlet) for macOS in QEMU + KVM and also [passthrough USB guide](https://github.com/foxlet/vmra1n)

