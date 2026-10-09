# Upstream 기준점

이 저장소는 Digilent 데모를 PetaLinux/Vivado 2025.2 로 옮긴 작업본이다.
아래 커밋을 출발점으로 삼았다 (만든 날짜: 2026-10-09).

| 구성 | 저장소 | 커밋 |
|------|--------|------|
| root (20/Petalinux/master) | https://github.com/Digilent/Zybo-Z7 | 450d6146d440464aed4b8e16ce8627bacaab2dab |
| hw | https://github.com/Digilent/Zybo-Z7-HW | 89b4a8e5f9f6f1579cb4768a9aeff0f3640093b9 |
| os (PetaLinux 2022.1 원본) | https://github.com/Digilent/Zybo-Z7-OS | 687e34544ab482e2b8a0a98f0f8653496ca17192 |
| sw (미사용) | https://github.com/Digilent/Zybo-Z7-SW | e49cc760710bdc48204e4efb6d2f6cf1a86dba94 |
| hw/scripts (submodule) | https://github.com/Digilent/digilent-vivado-scripts | ba6bbb948f13805db6172d3e04749671e685c9da |
| hw/repo/vivado-library (submodule) | https://github.com/Digilent/vivado-library | ab565ed50c85eaacb3e8b8fdce67a2a03ae779a4 |

커널 패치 원본: Digilent/linux-digilent `digilent_rebase_v5.15_LTS_2022.1`
U-Boot 패치 원본: Digilent/u-boot-digilent `digilent_rebase_v2022.01`
