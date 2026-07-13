####PROXMOX
#pvecm create cluster #na głównym serwerze 03 wykonujemy pvecm create cluster
#wykonaj poniższe komendy na hoście 03, potem po zalogowaniu ssh proxmoxhw0? na każdym innym
#curl http://pastebin.com/raw/bcqTc04Q | sed 's/\r$//'  > proxmox_ceph_init.sh      
cat << __EOF__ >> /root/.ssh/config
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
__EOF__
chmod 600 /root/.ssh/config
#ssh-keygen -t rsa -b 2048 -N '' -f /root/.ssh/id_rsa
server="proxmoxhw0"
host01="3"
host02="4"
host03="6"
host04="8"
echo "127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "192.168.10.5${host01} ${server}${host01}" >> /etc/hosts
echo "192.168.10.5${host02} ${server}${host02}" >> /etc/hosts
echo "192.168.10.5${host03} ${server}${host03}" >> /etc/hosts
echo "192.168.10.5${host04} ${server}${host04}" >> /etc/hosts
echo "10.10.10.1${host01} osd${host01}" >> /etc/hosts
echo "10.10.10.1${host02} osd${host02}" >> /etc/hosts
echo "10.10.10.1${host03} osd${host03}" >> /etc/hosts
echo "10.10.10.1${host04} osd${host04}" >> /etc/hosts
echo "deb http://download.proxmox.com/debian jessie pve-no-subscription" >> /etc/apt/sources.list
sed -i 's/^deb/#deb/g' /etc/apt/sources.list.d/pve-enterprise.list
apt-get update
apt-get dist-upgrade -y 
apt-get install -y curl iotop vim git lm-sensors
pvecm help
pvecm status
pvecm nodes
pveceph install -version hammer
apt-get dist-upgrade -y 
[ ! -d /mnt/SambaShare ] && mkdir /mnt/SambaShare
echo "//192.168.10.22/Images /mnt/SambaShare cifs username=piotr.wasiewicz,password=Pwa_1234,auto 0 0" >> /etc/fstab
echo "mount /mnt/SambaShare/" >> /etc/rc.local
sed -i 's/exit/\#exit/g' /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod 755 /etc/rc.local
update-rc.d rc.local defaults
update-rc.d rc.local enable
cat << __EOF__ >  /etc/systemd/system/rc-local.service 
[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExists=/etc/rc.local
 After=network.target
[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
 SysVStartPriority=99

[Install]
 WantedBy=multi-user.target
__EOF__
systemctl enable rc-local
[ ! -d /etc/ceph ] && mkdir /etc/ceph
ln -sfn /etc/pve/ceph.conf  /etc/ceph/ceph.conf  
/etc/init.d/kmod start   
update-rc.d kmod enable
curl ix.io/client > /usr/local/bin/ix
chmod +x /usr/local/bin/ix
#pvecm add proxmoxhw03 # po zalogowaniu ssh na innych od proxmoxhw03 serwerach dołącz je do klustera
##########################################################################################
#loguj się ssh proxmoxhw0? i wykonuj powyższe komendy
#od teraz bez hasła logowanie ssh proxmoxhw0?
##########################################################################################
#przez GUI skonfiguruj linux bridge z eth1 (tylko autostart ustawiony) i 10.10.10.1?
#set NIC1 10.10.10.1* network
#cat /etc/network/interfaces*
#restart serwer i sprawdź ssh osd? w razie potrzeby /etc/init.d/networking restart