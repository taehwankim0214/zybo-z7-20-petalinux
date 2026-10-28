# Zybo Z7-20 — PetaLinux / Vivado 2025.2

## Note

This repository is based on Digilent Demo and contains software from Digilent, modified to fit to Petalinux 2025.2.
Please refer to the note below for details.
This work is done by Claude, and although I tested and confirmed device recognition (HDMI, LAN), many features such as Pcam interface are not verified (and I have no plan to do so), so use it at your own risk.
This work is distributed with BSD Clause-3 License. If there's license confilct with upstream code, feel free to let me know.

Digilent [Zybo Z7-20 PetaLinux 데모](https://digilent.com/reference/programmable-logic/zybo-z7/demos/petalinux)를
Vivado 2025.2 / PetaLinux 2025.2 (linux-xlnx 6.12) 로 옮긴 작업본.
출발점이 된 Digilent 커밋은 [`docs/UPSTREAM.md`](docs/UPSTREAM.md), 바뀐 내용은 [`docs/MIGRATION.md`](docs/MIGRATION.md).

## 구성

```
hw/                 Vivado 소스 (Digilent Zybo-Z7-HW 기반)
  src/              블록디자인 tcl, XDC
  hw_handoff/       PetaLinux 에 넣는 XSA
  scripts/          submodule: digilent-vivado-scripts
  repo/vivado-library/  submodule: Digilent IP 라이브러리
os/                 PetaLinux 2025.2 프로젝트
  project-spec/meta-user/
    recipes-kernel/linux/linux-xlnx/   커널 패치 3개 + zybo-z7.cfg
    recipes-bsp/u-boot/                QSPI OTP MAC 패치 + zybo-z7.cfg
    recipes-bsp/device-tree/           system-user.dtsi
docs/
```

저장소에 넣지 않는 것: PetaLinux 설치본·인스톨러, `os/build`, `os/components`, `os/images`, Vivado `hw/proj`.

## 처음 받기

```bash
git clone --recurse-submodules git@github.com:<계정>/zybo-z7-20.git
cd zybo-z7-20
# --recurse-submodules 를 빼먹었다면:
git submodule update --init --recursive
```

## 하드웨어 (Vivado 2025.2)

```tcl
# Vivado Tcl 콘솔, 저장소 루트에서
source ./hw/scripts/checkout.tcl      ;# hw/proj 에 프로젝트 생성
# 합성/구현 후
write_hw_platform -fixed -include_bit -force -file ./hw/hw_handoff/system_wrapper.xsa
```

### 하드웨어 소스 갱신 (블록디자인을 고쳤을 때)

`hw/proj` 는 저장소에 들어가지 않으므로, 고친 블록디자인은 tcl 로 내보내야 남는다.

```tcl
open_bd_design [get_files system.bd]
write_bd_tcl -force -no_ip_version ./hw/src/bd/system.tcl
```

## 소프트웨어 (PetaLinux 2025.2)

```bash
source <PetaLinux 설치경로>/settings.sh
cd os
petalinux-config --get-hw-description ../hw/hw_handoff/ --silentconfig   # XSA 바뀌었을 때만
petalinux-build
petalinux-package boot --fsbl --fpga --u-boot --force
```

SD 카드 이미지 (image.ub 를 꼭 넣을 것):

```bash
petalinux-package wic --bootfiles "BOOT.BIN boot.scr image.ub"
# images/linux/petalinux-sdimage.wic 를 SD 에 기록
```

보드 전원은 HDMI/카메라를 쓸 때 외부 5V 어댑터(JP6=WALL) 권장 — USB 전원만으로는 부팅 중 리셋될 수 있음.
