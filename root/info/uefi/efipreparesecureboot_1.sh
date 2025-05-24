#!/bin/bash
set -e

WORKDIR=~/secureboot
EFIDIR=/boot/efi/EFI/Gentoo
GRUB_MODULES="part_gpt part_msdos ext2 fat configfile normal linux multiboot efi_gop efi_uga all_video gfxterm font"

mkdir -p "$WORKDIR/keys"
cd "$WORKDIR/keys"

echo "[1] Generuję klucze PK, KEK, db..."
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Platform Key/"  -keyout PK.key  -out PK.crt  -days 10000 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Key Exchange Key/" -keyout KEK.key -out KEK.crt -days 10000 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Signature Database/"  -keyout db.key  -out db.crt  -days 10000 -nodes -sha256

echo "[2] Tworzę pliki .esl..."
cert-to-efi-sig-list PK.crt  PK.esl
cert-to-efi-sig-list KEK.crt KEK.esl
cert-to-efi-sig-list db.crt  db.esl

openssl x509 -in PK.crt  -outform DER -out PK.cer
openssl x509 -in KEK.crt -outform DER -out KEK.cer
openssl x509 -in db.crt  -outform DER -out db.cer

echo "[3] Dodaję stare certyfikaty Microsoftu (jeśli istnieją)..."
efi-readvar -v PK  -o old_PK.esl || true
efi-readvar -v KEK -o old_KEK.esl || true
efi-readvar -v db  -o old_db.esl  || true
efi-readvar -v dbx -o old_dbx.esl || true

[ -f old_KEK.esl ] && cat old_KEK.esl >> KEK.esl
[ -f old_db.esl ]  && cat old_db.esl  >> db.esl

echo "[4] Tworzę pliki .auth do załadowania w BIOS/UEFI..."
sign-efi-sig-list -k PK.key  -c PK.crt  PK  PK.esl  PK.auth
sign-efi-sig-list -k PK.key  -c PK.crt  KEK KEK.esl KEK.auth
sign-efi-sig-list -k KEK.key -c KEK.crt db  db.esl  db.auth
sign-efi-sig-list -k KEK.key -c KEK.crt dbx old_dbx.esl dbx.auth

echo "[5] Tworzę klucz MOK do autoryzowania shim UEFI..."
openssl genrsa -out MOK.key 2048
openssl req -new -x509 -sha256 -days 3650 \
  -subj "/CN=Gentoo Secure Boot/" \
  -key MOK.key -out MOK.crt

openssl x509 -in MOK.crt -outform DER -out MOK.der
mokutil --import MOK.der

