#!/bin/bash
set -e

WORKDIR=~/secureboot
EFIDIR=/boot/efi/EFI/Gentoo
GRUB_MODULES="part_gpt part_msdos ext2 fat configfile normal linux multiboot efi_gop efi_uga all_video gfxterm font efi_signature verifiers lockdown"

cd "$WORKDIR/keys"

echo "[5] Tworzę standalone GRUB jako grubx64.efi..."
rm -rf "$WORKDIR/grub"
mkdir -p "$WORKDIR/grub"
grub-mkstandalone \
  --directory=/usr/lib/grub/x86_64-efi \
  --format=x86_64-efi \
  --output="$WORKDIR/grub/grubx64.efi" \
  --modules="$GRUB_MODULES" \
  --locales="" \
  --fonts="" \
  "boot/grub/grub.cfg=/boot/grub/grub.cfg"

echo "[6] Podpisuję grubx64.efi..."
sbsign --key "$WORKDIR/keys/db.key" --cert "$WORKDIR/keys/db.crt" \
  --output "$EFIDIR/grubx64.efi" "$WORKDIR/grub/grubx64.efi"

echo "[✔] Gotowe. grubx64.efi jest podpisany i gotowy do bootowania."
echo "Pliki *.auth możesz załadować w BIOS w trybie Custom Secure Boot:"
ls -lh "$WORKDIR/keys/"*.auth


