# PetaLinux 2022.1 → 2025.2 마이그레이션 노트

대상: `os/` (linux-xlnx 6.12 / u-boot-xlnx v2025.01, tag `xilinx-v2025.2`)
상태: 빌드 완료, 보드에서 리눅스 부팅·로그인 성공 (2026-10-09). 카메라 / HDMI 모니터 / 이더넷 연결 테스트 전.

## 왜 패치가 필요했나
Digilent 2022.1 프로젝트는 Digilent 포크 커널(`linux-digilent` 5.15)과 U-Boot(`u-boot-digilent`)를 받아 빌드했다.
2025.2 프로젝트는 Xilinx 기본 `linux-xlnx` / `u-boot-xlnx` 를 쓰므로 Digilent 전용 드라이버를 패치로 옮겼다.

## 커널 — `os/project-spec/meta-user/recipes-kernel/linux/linux-xlnx/`
- `0001-clk-add-Digilent-axi_dynclk-driver.patch` — HDMI 픽셀클럭(`dglnt,axi-dynclk`). devm_clk_hw_register, remove 제거
- `0002-drm-xlnx-add-Digilent-HDMI-encoder-driver.patch` — `digilent,hdmi`. drm_edid API, get_modes()가 항상 0을 반환하던 버그 수정, remove void
- `0003-drm-xlnx-add-digilent-hdmi-to-the-component-list.patch` — 6.12 xlnx_drv는 목록에 있는 노드만 component로 묶음. 없으면 HDMI 미바인딩
- `zybo-z7.cfg` — 예전 devtool-fragment.cfg / user_2021-09-16-08-08-00.cfg 대체 (APF·구형 FB·I2C debug 제거, ADI I2S·CSI2RXSS·FRMBUF·VDMA·DRM_XLNX·ULPI 추가)
- 검증: xilinx-v2025.2에 `git apply --check` OK, W=1 컴파일 경고 0

## U-Boot — `os/project-spec/meta-user/recipes-bsp/u-boot/`
- `0001-board-xilinx-zynq-read-MAC-address-from-QSPI-OTP.patch` — board_late_init()에서 QSPI OTP MAC 읽기 (S25FL128S/N25Q128/MT25QL128 → 0x4B@0x20, W25Q128 → 0x48@0x1000). 저장된 env의 ethaddr가 우선
- `zybo-z7.cfg` — `CONFIG_ZYNQ_GEM_SPI_MAC_OTP=y`
- `meta-xilinx-tools/recipes-bsp/uboot-device-tree/files/system-user.dtsi` — `&flash0` compatible/cells

## Device tree — `recipes-bsp/device-tree/files/system-user.dtsi`
- `chosen/bootargs` 제거 (SD ext4 rootfs용 자동 bootargs를 덮어쓰던 문제)
- `&flash0` 에 `#address-cells/#size-cells = <1>` (QSPI 파티션 파싱 오류)
- `&axi_vdma_1 dma-ranges` 삭제, `xilinx-vip.h` include 대신 값 직접 정의
- MIPI `xlnx,csi-pxl-format = <0x1e>` override 유지 (XSA는 0x18 생성)

## 프로젝트 config
- `CONFIG_SUBSYSTEM_EXTRA_BOOTARGS="uio_pdrv_genirq.of_id=generic-uio"` (+ `net.ifnames=0` 권장)
- rootfs: alsa, pulseaudio, v4l-utils, media-ctl, yavta, libv4l, libdrm(+tests), i2c-tools, fbset, gpio-demo, peekpoke

## 보드 테스트에서 겪은 것
- 메시지 없는 반복 리셋 → USB 전원 부족. HDMI/카메라 사용 시 외부 5V(JP6=WALL)
- `petalinux-package wic` 결과에 image.ub 누락 → `--bootfiles "BOOT.BIN boot.scr image.ub"`
- udev가 eth0 이름을 `enx…`로 바꿔 ifup 실패 → bootargs에 `net.ifnames=0`
- 주변장치 미연결 상태의 OV5640 power on 실패, DRM no crtc, DHCP no lease 는 정상

## 남은 것
- 주변장치 연결 테스트: `media-ctl -p` + yavta, `modetest -M xlnx`, 이더넷 DHCP
- 영상이 깨지면 Digilent ov5640 PLL 패치 포팅
- `realtek,leds-config` 는 6.12에서 무시됨
- petalinux-config Ethernet MAC 칸을 비우면 u-boot의 DT MAC/OTP MAC 불일치 경고가 사라짐
