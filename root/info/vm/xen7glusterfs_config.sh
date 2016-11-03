#USE IT IN COMMAND LINE (without #):
#curl http://pastebin.com/raw/LdtBkcTE > xendeletelocalsr.sh; tr -d "\015" < xendeletelocalsr.sh > xendeletelocalsrnew.sh
#sh xendeletelocalsrnew.sh
#I have managed to configure 4 servers of beta3 dundee with glusterfs and ctdb and fully working ha without SPOF.
#I have four NICs: NIC0 management of xenserver 192.168.10.2*, NIC1 gluster vm client 192.168.10.14*, bond NIC2-3 10.10.10.1*, VIPs #from ctdb 192.168.10.13*. In /etc/hosts #I keep only 10.10.10.1x server ips and use them in glusterfs volume creation and in #consequence in glusterfs backend traffic.
#The main compilation script:
#http://pastebin.com/hNsiyPyL
#Removing local storage and configuring ctdb, /etc/hosts:
#http://pastebin.com/LdtBkcTE
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
#init_brick $dev4gfs "vol0" #FOR GLUSTERFS

umount "/dev/sda2"
#init_brick "/dev/sda2" "vol1"  #FOR GLUSTERFS

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
ceph-deploy install --release jewel xen1 xen2 xen3
#ceph-deploy install --repo-url http://download.ceph.com/rpm-jewel/el7/ xen1 xen2 xen3
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