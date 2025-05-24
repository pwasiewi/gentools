#!/bin/bash
set -e

WORKDIR=~/secureboot
ESP=/boot/efi
EFIDIR=$ESP/EFI/GentooEFISTUB

# ESP disk and partition – adjust to your setup!
DISK=/dev/nvme0n1
PARTITION=1

# Path to the kernel and initrd
KERNEL="/root/kernel-genkernel-x86_64-6.14.6-zen1"
INITRD="/boot/initramfs-genkernel-x86_64-6.14.6-zen1"
CMDLINE="root=UUID=xxx-yyy-zzz ro quiet splash" # change UUID of the root partition

# Prepare working directories
mkdir -p "$WORKDIR/efistub"
mkdir -p "$EFIDIR"

# Embedding initrd and cmdline into the kernel (EFI Stub)
echo "[*] Embedding initrd and cmdline into the kernel (EFI Stub)..."

# Signing the kernel with db key (EFI Secure Boot) directly to ESP
echo "[*] Signing the kernel with db key (Secure Boot)..."
sbsign --key "$WORKDIR/keys/db.key" \
       --cert "$WORKDIR/keys/db.crt" \
       --output "$EFIDIR/vmlinuz-signed.efi" \
       "$KERNEL"

# Creating UEFI boot entry
echo "[*] Creating UEFI boot entry with efibootmgr..."
efibootmgr --create \
  --disk "$DISK" \
  --part "$PARTITION" \
  --label "Gentoo EFI Stub" \
  --loader '\EFI\GentooEFISTUB\vmlinuz-signed.efi'

echo "[✔] Done! You can now boot the kernel directly in Secure Boot mode (EFI Stub)."

