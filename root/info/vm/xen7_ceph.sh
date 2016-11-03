#Configure additional cards NIC1 (192.168.0.22?) i NIC2 (10.10.10.1?)
#USE IT IN COMMAND LINE (without #):
#curl http://pastebin.com/raw/SNnhH3rx > xendeletelocalsr.sh; tr -d "\015" < xendeletelocalsr.sh > xendeletelocalsrnew.sh
#sh xendeletelocalsrnew.sh
#I have managed to configure 4 servers of beta3 dundee with glusterfs and ctdb and fully working ha without SPOF.
#I have four NICs: NIC0 management of xenserver 192.168.0.20*, NIC1 gluster vm client 192.168.0.22*, bond NIC2-3 10.10.10.1*, VIPs #from ctdb 192.168.0.21*. In /etc/hosts #I keep only 10.10.10.1x server ips and use them in glusterfs volume creation and in #consequence in glusterfs backend traffic.
#The main compilation script
#Removing local storage and configuring ctdb, /etc/hosts:
#http://pastebin.com/SNnhH3rx
#At the end you should:
#gluster peer probe servers
#and
#init_gluster3 "xen" "1" "2" "3" "vol0" 3 #replica 3 at the end!
#create SR nfs and iso, make vm and install xen tools and enable ha with 3 failovers.
#You are encouraged to send some patches or opinions newfuntek(at)gmail.com
#Here are some screenshots of the glusterfs sr in the xenserver pool:
#http://s17.postimg.org/3y47n8w27/glusterfsxenserv03.jpg
#http://s17.postimg.org/n4heqfcjz/glusterfsxenserv01.jpg
#http://s17.postimg.org/gs29gl9hr/glusterfsxenserv02.jpg
####################################################################################################################################
#Internet help
#Xenserver doc links
#http://www.poppelgaard.com/citrix-xenserver-6-5
#http://www.gluster.org/community/documentation/index.php/GlusterFS_Documentation
#xenserver tutorials and cheatsheets
#http://www.admin-magazine.com/HPC/Articles/GlusterFS
#http://www.slashroot.in/gfs-gluster-file-system-complete-tutorial-guide-for-an-administrator 
#https://virtualizationandstorage.wordpress.com/2010/11/15/xenserver-commands/
#http://krypted.com/unix/using-the-xensource-command-line-interface/
#http://funwithlinux.net/2013/02/glusterfs-tips-and-tricks-centos/ 
#http://xmodulo.com/category/xenserver
#compilation of xenserver
#https://discussions.citrix.com/topic/372069-does-libvmi-work-on-xenserver/ 
#glusterfs slides info
#http://rajesh-joseph.blogspot.com/2015/11/usenix-lisa-2015-tutorial-on-glusterfs.html 
#https://github.com/gluster/gluster-tutorial/blob/master/LISA-GlusterFS-Introduction.pdf 
#https://github.com/gluster/gluster-tutorial/blob/master/LISA-GlusterFS-Hands-on.pdf 
#compilation of glusterfs
#http://majentis.com/?p=319 
#różne możliwości glusterfs jak w RAID
#http://sysadm.pp.ua/linux/glusterfs-setup.html 
#glusterfs performance
#https://blog.secretisland.de/xenserver-mit-glusterfs/ 
#http://blog.dradmin.co.in/?tag=glusterfs-how-to
#https://gluster.readthedocs.org/en/latest/Administrator%20Guide/Managing%20Volumes/
#https://www.mail-archive.com/users@ovirt.org/msg31079.html
#http://www.gluster.org/community/documentation/index.php/Performance_Testing
#glusterfs on lvm
#https://support.rackspace.com/how-to/getting-started-with-glusterfs-considerations-and-installation/ 
#glusterfs profiling (delays in ops)
#https://gluster.readthedocs.org/en/latest/Administrator%20Guide/Monitoring%20Workload/ 
#xenserver glusterfs discussion - they said not possible ;)
#http://discussions.citrix.com/topic/366729-about-xenserver-glusterfs/page-2
#xenserver ha
#http://docs.citrix.com/de-de/xencenter/6-1/xs-xc-protection/xs-xc-pools-ha/xs-xc-pools-ha-about.html 
#http://xapi-project.github.io/features/HA/HA.html
#https://support.citrix.com/servlet/KbServlet/download/21018-102-664364/High%20Availability%20for%20Citrix%20XenServer.pdf
#https://xen-orchestra.com/blog/xenserver-and-vm-high-availability/
#https://discussions.citrix.com/topic/367150-ntp-ha-self-fencing/page-2#entry1884695
#http://discussions.citrix.com/topic/333343-need-help-interpreting-xha-logs/
#failure ha restart
#http://support.citrix.com/article/CTX128275
#http://citrixtechs.com/blog/help-my-citrix-xenserver-poolmaster-is-down-2/
#http://discussions.citrix.com/topic/292757-local-storage-unplugged-and-un-repairable/
#xenserver iscsi
#http://gluster.readthedocs.org/en/latest/Administrator%20Guide/GlusterFS%20iSCSI/#Running_the_target_on_the_gluster_client
#xenserver multipath
#http://docs.citrix.com/content/dam/docs/en-us/xenserver/xenserver-61/xs-design-multipathing-config.pdf
#xenserver iptables discussion
#http://discussions.citrix.com/topic/235974-cannot-add-new-nfs-virtual-disk-sr-can-add-iso-library-nfs-sr/page-2 
#rebalance nics (bond for glusterfs)
#http://www.gluster.org/pipermail/gluster-users/2014-November/019463.html
#http://www.gluster.org/pipermail/gluster-users/2014-November/019466.html
#multi nic splitnetwork for gluster in near future
#https://www.gluster.org/pipermail/gluster-users/2015-May/021815.html
#http://www.gluster.org/community/documentation/index.php/Features/SplitNetwork
#http://pl.atyp.us/hekafs.org/index.php/2013/01/split-and-secure-networks-for-glusterfs/
#host in vm inside vm config
#https://wiki.openstack.org/wiki/XenServer/VirtualBox
#reinstall xenserver host
#http://support.citrix.com/article/CTX136342
#discuss rejoin xenserver
#http://discussions.citrix.com/topic/303468-server-removed-from-pool-after-failure-now-that-it-is-back-it-can-not-rejoin-pool-and-emergency-master-reset-does-not-work/
#increase dom0 memory
#http://support.citrix.com/article/CTX134951
#find rpm 
#http://rpm.pbone.net/ 
#win admin
#win7-10: Net user administrator /active:yes 
#umount /dev/v/l 
#e2fsck -f /dev/v/l 
#resize2fs -p /dev/v/l 4G 
#lvreduce -L -8.9G /dev/

####################################################################################################################################
#turn off nfs i iptables 
chkconfig nfs off 
service nfs stop
rm -f /etc/exports
service ntpd restart
chkconfig ntpd on
service iptables stop
chkconfig iptables off
systemctl disable firewalld
systemctl stop firewalld

#turn off selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/sysconfig/selinux
#change the linux name to Centos for CEPH-DEPLOY
mv /etc/centos-release /etc/centos-release.xs -f
echo 'CentOS release 7.2 (Final)' > /etc/centos-release

#new package update lists
#https://discussions.citrix.com/topic/372069-does-libvmi-work-on-xenserver/
#yum install epel-release 
#http://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/ 
#http://elrepo.org/tiki/tiki-index.php 
#rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org 
#rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm 
#wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
#rpm -ivh epel-release-7-6.noarch.rpm
#rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
#rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
#rpm -Uvh http://repo.webtatic.com/yum/el7/webtatic-release.rpm
sed -i -e "/baseurl=http:\/\/www.uk/d" /etc/yum.repos.d/CentOS-Base.repo
sed -i -e "/mirrorlist/d" /etc/yum.repos.d/CentOS-Base.repo
sed -i -e "s/^#base/base/" /etc/yum.repos.d/CentOS-Base.repo
sed -i -e "s/enabled=0/enabled=1/" /etc/yum.repos.d/CentOS-Base.repo
sed -i -e "s/\$releasever/7/" /etc/yum.repos.d/CentOS-Base.repo
yum install epel-release -y
yum install centos-release-gluster -y
sed -i -e "s/enabled=0/enabled=1/" /etc/yum.repos.d/CentOS-Gluster-3.7.repo
sed -i -e "s/\$releasever/7/" /etc/yum.repos.d/CentOS-Gluster-3.7.repo
sed -i -e "s/buildlogs.centos.org\/centos\/7\/storage\/\$basearch\/gluster-3.7/buildlogs.centos.org\/centos\/7\/storage\/\$basearch\/gluster-3.8/" /etc/yum.repos.d/CentOS-Gluster-3.7.repo
#sed -i -e "s/enabled=0/enabled=1/" /etc/yum.repos.d/epel-testing.repo
yum clean all
yum repolist enabled
yum -y install deltarpm
#yum update --skip-broken -y
yum -y install vim-enhanced mc yum-utils curl e4fsprogs epel-rpm-macros
curl ix.io/client > /usr/local/bin/ix
chmod +x /usr/local/bin/ix

yum install -y glusterfs glusterfs-api-devel python-gluster ctdb ceph-deploy bind-utils xfsprogs git dnsmasq xfsprogs ansible
#yum install -y open-vm-tools ## TYLKO DLA MASZYN WIRTUALNYCH VMWARE

#run serwis glusterfs
systemctl unmask rpcbind.socket
service glusterd start
service glusterd status
service glusterfsd start
service glusterfsd status
chkconfig glusterd on
chkconfig glusterfsd on

wget http://halizard.org/release/noSAN-combined/halizard_nosan_installer_1.4.7 
chmod 755 halizard_nosan_installer_1.4.7  
sed -i 's/`uname -r`/3.10.0+2/' halizard_nosan_installer_1.4.7

#curl http://ix.io/oxr > /etc/ntp.conf.ix 
#curl http://ix.io/ojO > /etc/ntp.conf.ix 
#gluster10_4nodes
#curl http://ix.io/op8 > /etc/ntp.conf.ix
#gluster_200_201 
#curl http://ix.io/oKN > /etc/ntp.conf.ix 
#gluster_201_202_203 
#curl http://ix.io/QLt > /etc/ntp.conf.ix 
#gluster10_3nodes
curl http://ix.io/Tm5 > /etc/ntp.conf.ix
tr -d "\015" < /etc/ntp.conf.ix > /etc/ntp.conf 
echo OPTIONS="-u ntp:ntp -p /var/run/ntpd.pid -x" > /etc/sysconfig/ntpd 
echo SYNC_HWCLOCK=yes >> /etc/sysconfig/ntpd
hwclock --systohc
service ntpd stop 
service ntpd start 
ntpstat -s 
ntpq -p 
ntpstat -s

echo "#/opt/xensource/bin/xe-toolstack-restart" >> /etc/rc.d/rc.local
echo "service glusterd restart" >> /etc/rc.d/rc.local 
echo "service glusterfsd restart" >> /etc/rc.d/rc.local 
echo "service ctdb restart" >> /etc/rc.d/rc.local 
chmod 755  /etc/rc.d/rc.local 

echo "xe host-emergency-ha-disable force=true" > /usr/local/bin/restartfence 
echo "/opt/xensource/bin/xe-toolstack-restart" >> /usr/local/bin/restartfence 
echo "service glusterd restart" >> /usr/local/bin/restartfence 
echo "service glusterfsd restart" >> /usr/local/bin/restartfence 
echo "service ctdb restart" >> /usr/local/bin/restartfence  
chmod 755 /usr/local/bin/restartfence

echo "/opt/xensource/bin/xe-toolstack-restart" >> /usr/local/bin/restartoolxen
echo "service glusterd restart" >> /usr/local/bin/restartoolxen
echo "service glusterfsd restart" >> /usr/local/bin/restartoolxen
echo "service ctdb restart" >> /usr/local/bin/restartoolxen
chmod 755 /usr/local/bin/restartoolxen

echo "service glusterd restart" > /usr/local/bin/restartdodatki
echo "service glusterfsd restart" >> /usr/local/bin/restartdodatki
echo "service ctdb restart" >> /usr/local/bin/restartdodatki
chmod 755 /usr/local/bin/restartdodatki

echo "service glusterd restart" > /usr/local/bin/restartgluster
echo "service glusterfsd restart" >> /usr/local/bin/restartgluster
chmod 755 /usr/local/bin/restartgluster

#init_gluster4 "xen" "1" "2" "3" "4" "vol0" 4
#server="xen"; host01="1"; host02="2"; host03="3"; host04="4"; volume="vol0"; replica=4; 
cat <<__EOF__ > /usr/local/bin/init_gluster4
server=\$1  
host01=\$2  
host02=\$3  
host03=\$4
host04=\$5  
volume=\$6
replica=\$7
gluster peer status
#na dowolnym jednym wykonac 
#glusterfs dwa volumeny vol0 (iso) I vol1 (gfs) na sda3 i sda2  
#gluster volume stop \$volume force 
#gluster volume delete \$volume force 
gluster volume create \$volume replica \$replica \${server}\${host01}:/export/\${server}\${host01}-\$volume \${server}\${host02}:/export/\${server}\${host02}-\$volume \${server}\${host03}:/export/\${server}\${host03}-\$volume \${server}\${host04}:/export/\${server}\${host04}-\$volume force  
gluster volume set \$volume nfs.port 2049  
gluster volume set \$volume performance.cache-size 128MB  
gluster volume set \$volume performance.write-behind-window-size 4MB  
gluster volume set \$volume performance.io-thread-count 64  
gluster volume set \$volume performance.io-cache on  
gluster volume set \$volume performance.read-ahead on  
gluster volume start \$volume  
gluster volume info \$volume  
gluster volume status \$volume  
#montowanie NFS SR pod localhost lub VIP :/vol0 lub vol1  
__EOF__
chmod 755 /usr/local/bin/init_gluster4 

#init_gluster3 "xen" "1" "2" "3" "vol0" 3
#server="xen"; host01="1"; host02="2"; host03="3"; volume="vol0"; replica=3; 
cat <<__EOF__ > /usr/local/bin/init_gluster3
server=\$1  
host01=\$2  
host02=\$3  
host03=\$4
volume=\$5
replica=\$6
gluster peer status
#na dowolnym jednym wykonac 
#glusterfs dwa volumeny vol0 (iso) I vol1 (gfs) na sda3 i sda2  
#gluster volume stop \$volume force 
#gluster volume delete \$volume force 
gluster volume create \$volume replica \$replica \${server}\${host01}:/export/\${server}\${host01}-\$volume \${server}\${host02}:/export/\${server}\${host02}-\$volume \${server}\${host03}:/export/\${server}\${host03}-\$volume force  
gluster volume set \$volume nfs.port 2049  
gluster volume set \$volume performance.cache-size 128MB  
gluster volume set \$volume performance.write-behind-window-size 4MB  
gluster volume set \$volume performance.io-thread-count 64  
gluster volume set \$volume performance.io-cache on  
gluster volume set \$volume performance.read-ahead on  
gluster volume start \$volume  
gluster volume info \$volume  
gluster volume status \$volume  
#montowanie NFS SR pod localhost lub VIP :/vol0 lub vol1  
__EOF__
chmod 755 /usr/local/bin/init_gluster3

#init_gluster2 "xen" "1" "2" "vol0" 2
#server="xen"; host01="1"; host02="2"; volume="vol0"; replica=2; 
cat <<__EOF__ > /usr/local/bin/init_gluster2
server=\$1  
host01=\$2  
host02=\$3   
volume=\$4
replica=\$5
gluster peer status
#na dowolnym jednym wykonac 
#glusterfs dwa volumeny vol0 (iso) I vol1 (gfs) na sda3 i sda2  
#gluster volume stop \$volume force 
#gluster volume delete \$volume force 
gluster volume create \$volume replica \$replica \${server}\${host01}:/export/\${server}\${host01}-\$volume \${server}\${host02}:/export/\${server}\${host02}-\$volume force  
gluster volume set \$volume nfs.port 2049  
gluster volume set \$volume performance.cache-size 128MB  
gluster volume set \$volume performance.write-behind-window-size 4MB  
gluster volume set \$volume performance.io-thread-count 64  
gluster volume set \$volume performance.io-cache on  
gluster volume set \$volume performance.read-ahead on  
gluster volume start \$volume  
gluster volume info \$volume  
gluster volume status \$volume  
#montowanie NFS SR pod localhost lub VIP :/vol0 lub vol1  
__EOF__
chmod 755 /usr/local/bin/init_gluster2 

#init_brick "/dev/sdb1" "vol2"
cat <<__EOF__ > /usr/local/bin/init_brick
dev4gfs=\$1  
volume=\$2  
hname=\`hostname\` 
mkfs.ext4 -m 0 -j \$dev4gfs
tune2fs -O dir_index -o user_xattr \$dev4gfs
mkdir -p /export/\${hname}-\${volume}
echo  "\$dev4gfs /export/\${hname}-\${volume} ext4 rw,noatime,nodiratime,user_xattr,barrier=0,data=ordered 1 2" >> /etc/fstab
mount -a 
__EOF__
chmod 755 /usr/local/bin/init_brick

#reformat_brick "/dev/sda2" "vol1"
cat <<__EOF__ > /usr/local/bin/reformat_brick
dev4gfs=\$1  
volume=\$2  
hname=\`hostname\` 
umount /export/\${hname}-\${volume}
mkfs.ext4 -m 0 -j \$dev4gfs
tune2fs -O dir_index -o user_xattr \$dev4gfs
mount /export/\${hname}-\${volume}
__EOF__
chmod 755 /usr/local/bin/reformat_brick

#removeallandformat "/dev/sdb" 
cat <<__EOF__ > /usr/local/bin/removeallandformat
#!/bin/bash
# Script to automatically format all partitions on /dev/sda and create 
# a single partition for the whole disk
# Remove each partition
for v_partition in \`parted -s \$1 print|awk '/^ / {print \$1}'\`; do umount \$1\${v_partition}; parted -s \$1 rm \${v_partition}; done
# Find size of disk
v_disk=\`parted -s \$1 print|awk '/^Disk \/dev/ {print \$3}'| sed 's/[Mm][Bb]//'\`
# Create single partition
parted -s \$1 mkpart primary 1 \${v_disk}
# Format the partition
# mke2fs -T ext3 \${1}1
__EOF__
chmod 755  /usr/local/bin/removeallandformat

####################################################################################################################################
#ctdb need compiling: SCHED_FIFO does not run in xenserver - how to enable it?
yum install gcc-c++ autoconf rpm-build -y
yum install popt-devel libtalloc-devel libtdb-devel libtevent-devel -y 

mkdir rpmbuild/SPECS -p; curl http://ix.io/QMh > rpmbuild/SPECS/ctdb.spec 
wget https://download.samba.org/pub/ctdb/ctdb-2.5.6.tar.gz -P rpmbuild/SOURCES 
rpmbuild -bp rpmbuild/SPECS/ctdb.spec 
sed -i "s/SCHED_FIFO/SCHED_OTHER/"  rpmbuild/BUILD/ctdb-2.5.6/common/system_util.c  
sed -i "s/p.sched_priority = 1/p.sched_priority = 0/"  rpmbuild/BUILD/ctdb-2.5.6/common/system_util.c  
rpmbuild -bc --short-circuit  rpmbuild/SPECS/ctdb.spec --noclean 
rpmbuild -bi --short-circuit  rpmbuild/SPECS/ctdb.spec --noclean 
rpmbuild -bb --short-circuit  rpmbuild/SPECS/ctdb.spec --noclean 
rpm -ivh rpmbuild/RPMS/x86_64/ctdb-* --nodeps --force
mv rpmbuild rpmbuild-ctdb -f
sed -i "s/^# CTDB_LOGFILE/CTDB_LOGFILE/" /etc/sysconfig/ctdb 
sed -i "s/^# CTDB_NODES/CTDB_NODES/" /etc/sysconfig/ctdb  
sed -i "s/^CTDB_RECOVERY_LOCK/# CTDB_RECOVERY_LOCK/" /etc/sysconfig/ctdb 
sed -i 's/Restart=no/Restart=always/' /usr/lib/systemd/system/ctdb.service 
#service smb stop
#chkconfig smb off

#compiling module ceph.ko for cephfs
wget http://downloadns.citrix.com.edgesuite.net/11624/XenServer-7.0.0-binpkg.iso
mkdir iso1; mount XenServer-7.0.0-binpkg.iso iso1
yum localinstall iso1/x86_64/kernel-* -y
#wget http://downloadns.citrix.com.edgesuite.net/11620/XenServer-7.0.0-DDK.iso
wget http://downloadns.citrix.com.edgesuite.net/11623/XenServer-7.0.0-source.iso
mkdir iso; mount XenServer-7.0.0-source.iso iso
rpm -ivh iso/kernel-3.10.96-484.383030.src.rpm 
rpmbuild -bp rpmbuild/SPECS/kernel.spec 
sed -i 's/# CONFIG_CEPH_FS is not set/CONFIG_CEPH_FS=m/g' rpmbuild/BUILD/kernel-3.10.96/linux-3.10.96/.config 
rpmbuild -bc --short-circuit  rpmbuild/SPECS/kernel.spec --noclean 
rpmbuild -bi --short-circuit  rpmbuild/SPECS/kernel.spec --noclean 
rpmbuild -bb --short-circuit  rpmbuild/SPECS/kernel.spec --noclean 
rpm -ivh rpmbuild/RPMS/x86_64/kernel-* --nodeps --force
#scp  rpmbuild/RPMS/x86_64/kernel-* xen2:
#scp  rpmbuild/RPMS/x86_64/kernel-* xen3:
#rpm -ivh kernel-* --nodeps --force


####################################################################################################################################
##CEPH XENSERVER
#http://www.virtualtothecore.com/en/quickly-build-a-new-ceph-cluster-with-ceph-deploy-on-centos-7/
#ntpd, no selinux, ssh-copy-id to do
useradd -d /home/cephuser -m cephuser
echo "cephuser ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cephuser
chmod 0440 /etc/sudoers.d/cephuser
sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers
git clone https://github.com/mstarikov/rbdsr.git
cd rbdsr
python ./install_rbdsr.py enable
####################################################################################################################################
###########################################################################
#uuid pbd http://blog.gluster.org/2012/ 
#usunięcie Local Storage na sda3 
#sformatowanie i podmontowanie dwóch wolnych partycji sda2 i sda3 na dwa dyski sieciowe
sed -i -e "s/metadata_read_only = 1/metadata_read_only = 0/" /etc/lvm/lvm.conf 
hname=`hostname` 
#hname=`echo $hname | tr [:lower:] [:upper:]` 
sruuid=`xe sr-list host=$hname name-label=Local\ storage --minimal` 
pbduid=`xe pbd-list sr-uuid=$sruuid --minimal` 
xe pbd-unplug uuid=$pbduid 
xe sr-forget uuid=$sruuid 
vgremove `vgdisplay -C | tail -n1 | cut -f3 -d' '` -f 
dev4gfs=`pvdisplay -C | tail -n1 | cut -f3 -d' '` 
pvremove $dev4gfs -f 

umount $dev4gfs
init_brick $dev4gfs "vol0"

umount "/dev/sda2"
init_brick "/dev/sda2" "vol1"

#FOR CEPH
parted -s /dev/sdb mklabel gpt mkpart primary xfs 0% 100%
#parted -s /dev/sdb mklabel gpt mkpart primary 0% 33% mkpart primary 34% 66% mkpart primary 67% 100%
mkfs.xfs /dev/sdb1 -f
#removeallandformat "/dev/sdb"
#init_brick "/dev/sdb1" "vol2"

###########################################################################
#OnePool
###########################################################################
server="xen"
host01="1"
host02="2"
host03="3"
echo "127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "10.10.10.1${host01} osd${host01}" >> /etc/hosts
echo "10.10.10.1${host02} osd${host02}" >> /etc/hosts
echo "10.10.10.1${host03} osd${host03}" >> /etc/hosts
echo "192.168.0.20${host01} ${server}${host01}" >> /etc/hosts
echo "192.168.0.20${host02} ${server}${host02}" >> /etc/hosts
echo "192.168.0.20${host03} ${server}${host03}" >> /etc/hosts
echo "10.10.10.1${host01}" > /etc/ctdb/nodes
echo "10.10.10.1${host02}" >> /etc/ctdb/nodes
echo "10.10.10.1${host03}" >> /etc/ctdb/nodes
echo "192.168.0.22${host01}/24 xenbr1" > /etc/ctdb/public_addresses
echo "192.168.0.22${host02}/24 xenbr1" >> /etc/ctdb/public_addresses
echo "192.168.0.22${host03}/24 xenbr1" >> /etc/ctdb/public_addresses
chkconfig ctdb on
#service ctdb restart

#init_gluster4 "xen" "1" "2" "3" "vol0" 3
#init_gluster4 "xen" "1" "2" "3" "vol1" 3
#service ctdb restart
#ctdb status

#https://serversforhackers.com/an-ansible-tutorial
#http://www.cyberciti.biz/faq/
[ -f /etc/ansible/hosts ] && mv /etc/ansible/hosts /etc/ansible/hosts.orig -f
echo "[web]" > /etc/ansible/hosts
echo "10.10.10.1${host01}" >> /etc/ansible/hosts
echo "10.10.10.1${host02}" >> /etc/ansible/hosts
echo "10.10.10.1${host03}" >> /etc/ansible/hosts
#ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa
#ssh-copy-id -i root@xen1
#ssh-copy-id -i root@xen2
#ssh-copy-id -i root@xen3
#ansible all -s -m shell -a "ctdb status"
echo 'ansible all -s -m shell -a "$1"' > /usr/local/bin/ae
chmod 700 /usr/local/bin/ae
#CRONTAB WORKS for test logs
[ -f /var/log/checktime.log ] && mv /var/log/checktime.log /var/log/checktime.log.old -f
echo 'echo "#########################"' > /usr/local/bin/checktime
echo "date" >> /usr/local/bin/checktime
echo "ntpstat -s" >> /usr/local/bin/checktime
echo "/sbin/gluster volume status vol2" >> /usr/local/bin/checktime
echo "ctdb status" >> /usr/local/bin/checktime
echo "free" >> /usr/local/bin/checktime
chmod 755 /usr/local/bin/checktime
echo "/usr/local/bin/checktime  2>&1 | cat >> /var/log/checktime.log" > /usr/local/bin/cronuserlogs
chmod 755 /usr/local/bin/cronuserlogs
echo "* * * * * /usr/local/bin/cronuserlogs" > ./cronwork
crontab -r
crontab ./cronwork
crontab -l

cat <<__EOF__ > /etc/logrotate.d/checktime
/var/log/checktime.log {
	daily
	rotate 3
	compress
	delaycompress
	missingok
	notifempty
	create 644 root root
}
__EOF__
cat <<__EOF__ > ~/.ssh/config
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
__EOF__
ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa
#for node in xen1 xen2 xen3 osd3 osd4 osd6; do ssh-copy-id $node ; done


#CEPH
#http://www.virtualtothecore.com/en/adventures-ceph-storage-part-1-introduction/
#https://blog.zhaw.ch/icclab/tag/ceph/
#https://wiki.centos.org/SpecialInterestGroup/Storage/ceph-Quickstart
#http://linoxide.com/storage/setup-red-hat-ceph-storage-centos-7-0/
#http://karan-mj.blogspot.com/2013/12/what-is-ceph-ceph-is-open-source.html
#https://www.reddit.com/r/DataHoarder/comments/4gzpxi/why_is_ceph_so_rare_for_home_use_even_among/
#http://palmerville.github.io/2016/04/30/single-node-ceph-install.html
cat <<__EOF__ >> ./ceph.conf
mon_pg_warn_max_per_osd = 0
public network = 192.168.0.0/24
cluster network = 10.10.10.0/24
#Choose reasonable numbers for number of replicas and placement groups.
osd pool default size = 2 # Write an object 2 times
osd pool default min size = 1 # Allow writing 1 copy in a degraded state
osd pool default pg num = 256
osd pool default pgp num = 256
#Choose a reasonable crush leaf type
#0 for a 1-node cluster.
#1 for a multi node cluster in a single rack
#2 for a multi node, multi chassis cluster with multiple hosts in a chassis
#3 for a multi node cluster with hosts across racks, etc.
osd crush chooseleaf type = 1
[osd.0]
public addr = 192.168.0.53
cluster addr = 10.10.10.13
host = osd3
devs = /dev/sdb
osd journal = /dev/sda2
[osd.1]
public addr = 192.168.0.54
cluster addr = 10.10.10.14
host = osd4
devs = /dev/sdb
osd journal = /dev/sda2
[osd.2]
public addr = 192.168.0.56
cluster addr = 10.10.10.16
host = osd6
devs = /dev/sdb
osd journal = /dev/sda2
__EOF__

 
cat <<__EOF__ > /usr/local/bin/init_ceph
server="xen"
host01="1"
host02="2"
host03="3"
[ ! -d ceph-deploy ] && mkdir ceph-deploy
cd ceph-deploy/
ceph-deploy purge xen1 xen2 xen3
ceph-deploy purgedata xen1 xen2 xen3
ceph-deploy forgetkeys
ceph-deploy new xen1 xen2 xen3
#ceph-deploy install --release jewel --no-adjust-repos xen1 xen2 xen3
#ceph-deploy install --release jewel xen1 xen2 xen3
ceph-deploy install --repo-url http://download.ceph.com/rpm-jewel/el7/ xen1 xen2 xen3
ceph-deploy --overwrite-conf mon create-initial

ceph-deploy gatherkeys xen1
for i in osd3 osd4 osd6; do ceph-deploy disk zap $i:sdb; done
ae "parted -s /dev/sdb mklabel gpt mkpart primary xfs 0% 100%"
ae "mkfs.xfs /dev/sdb1 -f"
#http://tracker.ceph.com/issues/13833
ae "chown ceph:ceph /dev/sda2"
for i in osd3 osd4 osd6; do 
ceph-deploy osd prepare \$i:/dev/sdb1:/dev/sda2; done
for i in osd3 osd4 osd6; do 
ceph-deploy osd activate \$i:/dev/sdb1:/dev/sda2; done
#ceph-deploy  --username ceph osd create osd3:/dev/sdb1:/dev/sda2
ceph-deploy admin xen1 xen2 xen3 osd3 osd4 osd6
ae "chmod +r /etc/ceph/ceph.client.admin.keyring"
ae "systemctl enable ceph-mon.target"
ae "systemctl enable ceph-mds.target"
ae "systemctl enable ceph-osd.target"
#object storage gateway
ceph-deploy rgw create xen1 xen2 xen3
#cephfs
ceph-deploy mds create xen1 xen2 xen3
ceph -s #ceph status
ceph osd tree
ceph mon_status
ceph osd pool create mypool 1
ceph osd lspools
ceph df
echo "test data" > testfile
rados put -p mypool testfile testfile
rados -p mypool ls
rados -p mypool setomapval testfile mykey myvalue
rados -p mypool getomapval testfile mykey
rados get -p mypool testfile testfile2
md5sum testfile testfile2 

ceph osd pool create cephfs_data 128
ceph osd pool create cephfs_metadata 128
ceph fs new cephfs cephfs_metadata cephfs_data
mkdir /mnt/mycephfs
mount -t ceph xen1:6789:/ /mnt/mycephfs -o name=admin,secret=`cat ./ceph.client.admin.keyring | grep key | cut -f 2 | sed 's/key = //g'`
__EOF__


echo 'Configure NIC1 (192.168.0.22?) i NIC2 (10.10.10.1?)'
echo 'for node in xen1 xen2 xen3 osd3 osd4 osd6; do ssh-copy-id $node ; done'

echo 'FOR GLUSTER Execute on one server:'
echo 'gluster peer probe xen1'
echo 'gluster peer probe xen2'
echo 'gluster peer probe xen3'
#echo 'gluster peer probe xen4'
echo 'init_gluster4 "xen" "1" "2" "3" "vol0" 3'
echo 'init_gluster4 "xen" "1" "2" "3" "vol1" 3'
echo 'ae "service ctdb restart"'
echo 'ae "ctdb status"'
#echo 'ip addr show | grep inet'
#echo "ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa"
echo 'Mount SR iso, gfs1, gfs2'

echo 'FOR CEPH execute on one server'
echo '/usr/local/bin/init_ceph'

#END