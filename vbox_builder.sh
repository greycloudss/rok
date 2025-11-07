#!/usr/bin/env bash
set -euo pipefail
rm -rf ./build/
mkdir -p build

nasm -f bin boot/bios_s1.asm -o build/boot.bin
nasm -f bin boot/bios_s2.asm -o build/stage2.bin

truncate -s 20M build/hd.img

dd if=build/boot.bin   of=build/hd.img bs=512 count=1 conv=notrunc status=none
dd if=build/stage2.bin of=build/hd.img bs=512 seek=1  conv=notrunc status=none

VBoxManage convertfromraw build/hd.img build/hd.vdi --format VDI
echo "VirtualBox image finished building, dir: ./build/"
