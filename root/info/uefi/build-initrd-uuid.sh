#!/bin/bash
set -euo pipefail

UUID="f3063347-af75-4235-9f19-a2ac3d46c300"
SQUASHFS_NAME="livecd.squashfs"
OUT_INITRD="initrd.uuid.cpio.gz"
WORKDIR="initrd-root"
BUSYBOX_VER="1.37.0"
BUSYBOX_TAR="busybox-${BUSYBOX_VER}.tar.bz2"
BUSYBOX_URL="https://busybox.net/downloads/${BUSYBOX_TAR}"
BUSYBOX_DIR="busybox-${BUSYBOX_VER}"

echo "📥 Pobieram BusyBox $BUSYBOX_VER..."
rm -rf "$BUSYBOX_DIR"
wget -q "$BUSYBOX_URL"
tar -xjf "$BUSYBOX_TAR"

echo "⚙️  Konfiguruję BusyBox (static, bez tc)..."
cd "$BUSYBOX_DIR"
make distclean
make defconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/CONFIG_TC=y/# CONFIG_TC is not set/' .config

echo "🔨 Kompiluję BusyBox..."
make -j$(nproc)
cd ..

echo "📦 Tworzę strukturę initrd..."
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"/{bin,sbin,etc,proc,sys,dev,mnt/cdrom,mnt/root}

cp "$BUSYBOX_DIR/busybox" "$WORKDIR/bin/busybox"
chmod +x "$WORKDIR/bin/busybox"

echo "🔗 Tworzę aliasy BusyBoxa..."
cd "$WORKDIR/bin"
for i in \
  sh mount umount mkdir ls cp mv rm blkid echo cat sleep dmesg \
  switch_root uname vi more ps kill df free grep head tail which pwd \
  true false test stat cut sed awk ping traceroute clear whoami hostname \
  readlink basename dirname yes reset wc uptime reboot poweroff \
  ; do
  ln -sf busybox "$i"
done
cd - > /dev/null

echo "🧾 Tworzę skrypt init..."
cat > "$WORKDIR/init" <<EOF
#!/bin/sh
set -e

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs devtmpfs /dev

echo "[*] Urządzenia w /dev:"
ls /dev
blkid

[ ! -e /dev/console ] && mknod /dev/console c 5 1

echo "Wypisuje na konsole..." >/dev/console

LIVE_UUID="$UUID"
LIVE_MNT="/mnt/cdrom"
ROOT_MNT="/mnt/root"
SQUASHFS_NAME="$SQUASHFS_NAME"
TMP_WORK="/mnt/overlaytmp"

mkdir -p "\$LIVE_MNT" "\$ROOT_MNT" "\$TMP_WORK"
mount -t tmpfs -o size=2048M tmpfs "\$TMP_WORK"

echo ">>> Szukam urządzenia UUID=\$LIVE_UUID"

sleep 2

i=0
while [ \$i -lt 40 ]; do
    DEV_PATH=\$(blkid | grep "\$LIVE_UUID" | cut -d: -f1)
    if [ -n "\$DEV_PATH" ]; then
        echo "Znaleziono urządzenie: \$DEV_PATH"
        break
    fi
    echo "Czekam na urządzenie USB (UUID=\$LIVE_UUID)..."
    sleep 1
    i=\$((i + 1))
done

if [ -z "\$DEV_PATH" ]; then
  echo "!!! Nie znaleziono partycji o UUID \$LIVE_UUID"
  blkid
  cat /proc/bus/input/devices
  ls /dev/input
  exec sh </dev/console >/dev/console 2>&1
fi

echo ">>> Montuję \$DEV_PATH -> \$LIVE_MNT"
mount "\$DEV_PATH" "\$LIVE_MNT"

if [ ! -f "\$LIVE_MNT/\$SQUASHFS_NAME" ]; then
  echo "!!! Brak \$SQUASHFS_NAME w \$LIVE_MNT"
  exec sh
fi

echo ">>> Montuję squashfs: \$SQUASHFS_NAME -> \$ROOT_MNT"
mount -t squashfs -o loop "\$LIVE_MNT/\$SQUASHFS_NAME" "\$ROOT_MNT"

echo ">>> Przenoszę katalogi do RAM (tmpfs): home var mnt etc"
for dir in home var mnt etc tmp; do
    echo ">>> Przygotowuję /\$dir w RAM"
    mkdir -p "\$TMP_WORK/\$dir"

    if [ -d "\$ROOT_MNT/\$dir" ]; then
        echo ">>> Kopiuję zawartość /\$dir do RAM"
        cp -a "\$ROOT_MNT/\$dir/." "\$TMP_WORK/\$dir/"
    fi

    echo ">>> Nakładam RAM-ową wersję /\$dir"
    mount -o bind "\$TMP_WORK/\$dir" "\$ROOT_MNT/\$dir"
done

echo ">>> switch_root -> system"
exec switch_root "\$ROOT_MNT" /sbin/init

echo "!!! switch_root nie powiódł się"
exec sh
EOF


chmod +x "$WORKDIR/init"

echo "🗜 Kompresuję initrd..."
cd "$WORKDIR"
find . | cpio -H newc -o | gzip -9 > "../$OUT_INITRD"
cd ..

echo "✅ Gotowe: $OUT_INITRD"

