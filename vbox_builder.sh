#!/usr/bin/bash
set -euo pipefail
mkdir -p build
nasm -f bin boot/bios_s1.asm -o ./build/boot.bin

size=$(stat -c%s build/boot.bin)

if [[ "$size" -ne 512 ]]; then
	echo "[Error] build/boot.bin is $size bytes (must be 512)"
	exit 1
fi
tail -c 2 build/boot.bin | hexdump -v -e '1/1 "%02X "' | grep -q "^55 AA " || {
	echo "[Error] boot signature not found (expected 55 AA at end)"
	exit 1
}

dd if=/dev/zero of=./build/hd.img bs=1M count=20
dd if=./build/boot.bin of=./build/hd.img conv=notrunc
VBoxManage convertfromraw ./build/hd.img ./build/hd.vdi --format VDI
echo "VirtualBox image finished building, dir: ./build/"
