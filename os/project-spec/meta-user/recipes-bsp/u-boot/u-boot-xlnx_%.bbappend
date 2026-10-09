FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://platform-top.h file://bsp.cfg"

# Zybo Z7-20: MAC address from QSPI OTP (ported from u-boot-digilent)
SRC_URI:append = " \
    file://0001-board-xilinx-zynq-read-MAC-address-from-QSPI-OTP.patch \
    file://zybo-z7.cfg \
"
