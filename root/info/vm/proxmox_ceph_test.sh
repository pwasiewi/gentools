#curl http://pastebin.com/raw/TcCjATwn | sed 's/\r$//'  > proxmox_ceph_test.sh   
#sh proxmox_ceph_test.sh  
#curl ix.io/client > /usr/local/bin/ix
#chmod +x /usr/local/bin/ix
#git clone https://github.com/bengland2/smallfile.git; cd smallfile
#ssh-keygen -t rsa -b 2048 -N '' -f /root/.ssh/id_rsa
#ssh-copy-id -i root@localhost
echo 1 > /proc/sys/vm/drop_caches; sync
./smallfile_cli.py --top . --host-set localhost --threads 8 --file-size 4 --files 10000 --response-times Y --operation create 2>&1 | cat > out_smallfile_res.txt
echo 1 > /proc/sys/vm/drop_caches; sync
./smallfile_cli.py --top . --host-set localhost --threads 8 --file-size 4 --files 10000 --response-times Y --operation read  2>&1 | cat >> out_smallfile_res.txt
echo 1 > /proc/sys/vm/drop_caches; sync
./smallfile_cli.py --top . --host-set localhost --threads 8 --file-size 4 --files 10000 --response-times Y --operation append 2>&1 | cat >> out_smallfile_res.txt
echo 1 > /proc/sys/vm/drop_caches; sync
./smallfile_cli.py --top . --host-set localhost --threads 8 --file-size 4 --files 10000 --response-times Y --operation rename 2>&1 | cat >> out_smallfile_res.txt
echo 1 > /proc/sys/vm/drop_caches; sync
./smallfile_cli.py --top . --host-set localhost --threads 8 --file-size 4 --files 10000 --response-times Y --operation delete 2>&1 | cat >> out_smallfile_res.txt