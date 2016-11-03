MAKEOPTS="-j8 -l16" genkernel --makeopts=-j8 --kernel-config=/usr/src/linux/.config --no-clean --lvm --luks all
time crossdev --target i686-none-linux-gnueabi --gcc 5.4.0  --libc 2.23 --kernel 4.7.5
mkdir /usr/armv7a-hardfloat-linux-gnueabi/usr/local/bin -pv && gcc -static qemu-wrapper.c -Ofast -s -o /usr/armv7a-hardfloat-linux-gnueabi/usr/local/bin/qemu-wrapper
cat compw/size.txt | sort -k2 -n
module-rebuild rebuild
lafilefixer --justfixit
mkfs -t vfat -n FreeDOS /dev/sdd
qemu -hda /dev/sdd -cdrom /home/guest/pliki/fdbasecd.iso -boot d
qemu -hda /dev/sdd -boot c
rlwrap sqlplus / as sysdba
syslinux /dev/sdx
perl -MCPAN -e shell
chown -R guest:users /home/guest/
chown -R postgres:postgres /var/lib/postgresql/
chown -R hadoop:hadoop /hadoop/
chown -R oracle:oinstall /home/oracle/
mkfs.ext4 -E stripe_width=128,stride=128 /dev/sdxx
mkfs.ext4 -E stripe_width=2,stride=384 /dev/sdxx #for samsung evo
tune2fs -O has_journal -o journal_data_writeback /dev/sdxx
tune2fs -o discard /dev/sdxx
tar Jcvf portage`date +%y%m%d`.txz .portage; tar Jcvf layman`date +%y%m%d`.txz .layman
grub-mkconfig -o /boot/grub/grub.cfg
vim /etc/modprobe.d/blacklist.conf
vim /etc/portage/package.keywords/package.keywords
vim /etc/portage/package.use/package.use
vim /etc/portage/package.unmask/package.unmask
vim /etc/portage/profile/package.provided 
vim /etc/portage/package.env
emerge @preserved-rebuild
emerge --metadata; layman -s ALL; eix-update;emerge -uND world --keep-going -av
emaint -A sync; eix-update
eix-update
eval `ssh-agent -s`
eselect postgresql list
for i in '/etc/portage' '/usr/local/portage'; do cp2home $i g; cp2konfig $i; done
emerge encfs cryptsetup lvm2 wireless-tools
vim /usr/share/genkernel/defaults/initrd.defaults
emerge -uND world --keep-going -av
dmraid -ayes
su - postgres
su - oracle
systemctl start systemd-binfmt
optirun glxspheres64
systemctl enable wpa_supplicant@wlp3s0
systemctl enable bumblebeed
systemctl restart systemd-binfmt
systemctl start wpa_supplicant@wlp3s0
systemctl start bumblebeed
su - guest
