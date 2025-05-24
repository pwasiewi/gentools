#!/bin/bash
set -e

# Ścieżka do ESP (EFI System Partition)
ESP=/boot/efi

# Dysk i partycja ESP – dostosuj zgodnie z rzeczywistością!
DISK=/dev/nvme0n1
PARTITION=1

# Katalog docelowy na ESP
DEST_DIR="$ESP/EFI/GentooShim"
mkdir -p "$DEST_DIR"

# Ścieżki i pliki
WORKDIR=~/secureboot
MOK_KEY="$WORKDIR/keys/MOK.key"
MOK_CRT="$WORKDIR/keys/MOK.crt"

# Moduły GRUB (minimum do bootowania EFI + Linux)
GRUB_MODULES="part_gpt part_msdos ext2 fat configfile normal linux efi_gop efi_uga all_video gfxterm font"

# Konfiguracja GRUB-a (jeśli nie masz, możesz zmienić ścieżkę)
GRUB_CFG="/boot/grub/grub.cfg"

# 1. Tworzenie standalone GRUB
echo "[1] Buduję GRUB jako grubx64.efi..."
mkdir -p "$WORKDIR/shim-grub"
grub-mkstandalone \
  --directory=/usr/lib/grub/x86_64-efi \
  --format=x86_64-efi \
  --output="$WORKDIR/shim-grub/grubx64.efi" \
  --modules="$GRUB_MODULES" \
  --locales="" \
  --fonts="" \
  "boot/grub/grub.cfg=$GRUB_CFG"

# 2. Podpisanie GRUB-a kluczem MOK
echo "[2] Podpisuję GRUB kluczem MOK..."
sbsign --key "$MOK_KEY" --cert "$MOK_CRT" \
  --output "$DEST_DIR/grubx64.efi" "$WORKDIR/shim-grub/grubx64.efi"

cp /usr/share/shim/BOOTX64.EFI "$DEST_DIR/shimx64.efi"
cp /usr/share/shim/mmx64.efi "$DEST_DIR/"
cp ~/secureboot/keys/MOK.der "$DEST_DIR/"

# Tworzenie wpisu UEFI
efibootmgr --create \
  --disk "$DISK" \
  --part "$PARTITION" \
  --label "Gentoo Shim Boot" \
  --loader '\EFI\GentooShim\shimx64.efi'

echo "[✔] GRUB podpisany i zapisany z shim w: $DEST_DIR/grubx64.efi\n mokutil --import $DEST_DIR/MOK.der"

