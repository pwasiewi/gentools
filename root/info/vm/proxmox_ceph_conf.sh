[global]
	 auth client required = cephx
	 auth cluster required = cephx
	 auth service required = cephx
	 cluster network = 10.10.10.0/24
	 debug asok = 0/0
	 debug auth = 0/0
	 debug bluestore = 0/0
	 debug buffer = 0/0
	 debug client = 0/0
	 debug context = 0/0
	 debug crush = 0/0
	 debug filer = 0/0
	 debug filestore = 0/0
	 debug finisher = 0/0
	 debug hadoop = 0/0
	 debug heartbeatmap = 0/0
	 debug journal = 0/0
	 debug journaler = 0/0
	 debug lockdep = 0/0
	 debug log = 0
	 debug mds = 0/0
	 debug mds_balancer = 0/0
	 debug mds_locker = 0/0
	 debug mds_log = 0/0
	 debug mds_log_expire = 0/0
	 debug mds_migrator = 0/0
	 debug mon = 0/0
	 debug monc = 0/0
	 debug ms = 0/0
	 debug objclass = 0/0
	 debug objectcacher = 0/0
	 debug objecter = 0/0
	 debug optracker = 0/0
	 debug osd = 0/0
	 debug paxos = 0/0
	 debug perfcounter = 0/0
	 debug rados = 0/0
	 debug rbd = 0/0
	 debug rgw = 0/0
	 debug throttle = 0/0
	 debug timer = 0/0
	 debug tp = 0/0
	 filestore xattr use omap = true
	 fsid = 2ac8f86b-5a0f-47a3-afd7-3a05773a811e
	 keyring = /etc/pve/priv/$cluster.$name.keyring
	 mon_pg_warn_max_per_osd = 0
	 osd crush chooseleaf type = 2
	 osd journal size = 5120
	 osd pool default min size = 1
	 public network = 192.168.10.0/24

[client]
	 rbd cache = true
	 rbd cache max dirty = 134217728
	 rbd cache max dirty age = 5
	 rbd cache size = 268435456

[osd]
	 filestore max sync interval = 100
	 filestore min sync interval = 50
	 filestore queue committing max bytes = 536870912
	 filestore queue committing max ops = 2000
	 filestore queue max bytes = 536870912
	 filestore queue max ops = 2000
	 filestore xattr use omap = true
	 journal max write bytes = 1073714824
	 journal max write entries = 10000
	 journal queue max bytes = 10485760000
	 journal queue max ops = 50000
	 keyring = /var/lib/ceph/osd/ceph-$id/keyring
	 osd client message size cap = 2147483648
	 osd data = /var/lib/ceph/osd/ceph-$id
	 osd deep scrub stride = 131072
	 osd disk threads = 4
	 osd journal size = 20000
	 osd map cache bl size = 128
	 osd map cache size = 1024
	 osd max backfills = 1
	 osd max write size = 512
	 osd mkfs options xfs = "-f  -i size=2048"
	 osd mkfs type = xfs
	 osd mount options xfs = "rw,noatime,nodiratime,nobarrier,logbsize=256k,logbufs=8,inode64,allocsize=4M"
	 osd op threads = 8
	 osd recovery max active = 1
	 osd recovery op priority = 4

[mon.2]
	 host = prox06
	 mon addr = 10.10.10.16:6789

[mon.3]
	 host = prox08
	 mon addr = 10.10.10.18:6789

[mon.1]
	 host = prox04
	 mon addr = 10.10.10.14:6789

[mon.0]
	 host = prox03
	 mon addr = 10.10.10.13:6789

[osd.2]
	 cluster addr = 10.10.10.16
	 host = osd6
	 public addr = 192.168.10.56

[osd.1]
	 cluster addr = 10.10.10.14
	 host = osd4
	 public addr = 192.168.10.54

[osd.0]
	 cluster addr = 10.10.10.13
	 host = osd3
	 public addr = 192.168.10.53

[osd.3]
	 cluster addr = 10.10.10.18
	 host = osd8
	 public addr = 192.168.10.58
