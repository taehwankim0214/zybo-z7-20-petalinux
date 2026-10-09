FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"

# Zybo Z7-20 demo: Digilent drivers ported from linux-digilent (5.15) to 6.12
SRC_URI += " \
    file://0001-clk-add-Digilent-axi_dynclk-driver.patch \
    file://0002-drm-xlnx-add-Digilent-HDMI-encoder-driver.patch \
    file://0003-drm-xlnx-add-digilent-hdmi-to-the-component-list.patch \
    file://zybo-z7.cfg \
"
