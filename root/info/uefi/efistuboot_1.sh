#!/bin/bash
set -e

WORKDIR=~/secureboot
ESP=/boot/efi
EFIDIR=$ESP/EFI/GentooEFISTUB

# Dysk i partycja ESP – dostosuj zgodnie z rzeczywistością!
DISK=/dev/nvme0n1
PARTITION=1

# Ścieżka do kernela i initrd
KERNEL="/root/kernel-genkernel-x86_64-6.14.6-zen1"
INITRD="/boot/initramfs-genkernel-x86_64-6.14.6-zen1"
#CMDLINE="root=UUID=bd7b28eb-6b32-4198-8db7-3499b060f3b3 ro quiet splash" # zmień UUID partycji root
CMDLINE="root=/dev/nvme0n1p7 ro quiet splash" 

# Przygotowanie katalogów roboczych
mkdir -p "$WORKDIR/efistub"
mkdir -p "$EFIDIR"

# Osadzanie initrd i cmdline w kernelu (EFI Stub)
echo "[*] Osadzam initrd i cmdline w kernelu (EFI Stub)..."

# Podpisanie kernela kluczem db (EFI Secure Boot) bezpośrednio do ESP
echo "[*] Podpisuję kernel kluczem db (Secure Boot)..."
sbsign --key "$WORKDIR/keys/db.key" \
       --cert "$WORKDIR/keys/db.crt" \
       --output "$EFIDIR/vmlinuz-signed.efi" \
       "$KERNEL"

echo "[✔] Gotowe! Możesz bootować bezpośrednio kernel w trybie Secure Boot (EFI Stub)."

