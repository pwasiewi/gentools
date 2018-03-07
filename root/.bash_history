eselect kernel set `eselect kernel list | grep linux | wc -l`
epm -qai | grep -E "^Name|^Size"  >compw/size.txt 
cat compw/size.txt | sort -k2 -n
module-rebuild rebuild
lafilefixer --justfixit
v a e
emerge `epm -qa | grep xf86| awk '{print "="$1}' -`
mkfs -t vfat -n FreeDOS /dev/sdd
qemu-system-i386 -hda /dev/sde -cdrom /usr/local/share/pliki/fdbasecd.iso -boot d
qemu-system-i386 -hda /dev/sdd -boot c
rlwrap sqlplus / as sysdba
syslinux /dev/sdd1
perl -MCPAN -e shell
chown -R guest:users /home/guest/
chown -R postgres:postgres /var/lib/postgresql/
chown -R hadoop:hadoop /hadoop
chown -R oracle:oinstall /home/oracle
mkfs.ext4 -E stripe_width=128,stride=128 /dev/sdxx
tune2fs -O has_journal -o journal_data_writeback /dev/sdxx
tar Jcvf portage`date +%y%m%d`.txz .portage; tar Jcvf layman`date +%y%m%d`.txz .layman
8z portage`date +%y%m%d` .portage ; 8z layman`date +%y%m%d`.txz .layman
grub-mkconfig -o /boot/grub/grub.cfg
vim /usr/local/bin/DetectedX 
vim /etc/modprobe.d/blacklist.conf
vim /etc/portage/package.keywords/package.keywords
vim /etc/portage/package.use/package.use
vim /etc/portage/package.unmask/package.unmask
vim /etc/portage/profile/package.provided 
vim /etc/portage/package.env
emerge @preserved-rebuild
emerge --metadata; layman -s ALL; eix-update;emerge -uND world --keep-going -av
emaint -A sync; layman -s ALL; eix-update
pmaint sync; eix-update
eix-update
eselect postgresql set 1.9
for i in '/etc/portage' '/usr/local/portage'; do cp2home $i a; cp2konfig $i; done
emerge encfs cryptsetup lvm2 wireless-tools
vim /usr/share/genkernel/defaults/initrd.defaults
MAKEOPTS="-j8 -l16" genkernel --makeopts=-j8 --kernel-config=/usr/src/linux/.config --lvm --luks --no-clean all
emerge -uND world --keep-going -av
dmraid -ayes
su - postgres
su - oracle
time crossdev --target i686-none-linux-gnueabi --gcc 5.4.0  --libc 2.23 --kernel 4.7.5
optirun glxspheres64
systemctl enable wpa_supplicant@wlp3s0
systemctl enable bumblebeed
systemctl restart systemd-binfmt
systemctl start wpa_supplicant@wlp3s0
systemctl start bumblebeed
su - guest
