Zamontowac partycję z kernelami:
mount /dev/sdx /mnt/key
cp -a /boot/kernel/* /mnt/key
Edytowac dodajac poprzednio sformatowane partycje do plikow konfiguracyjnych:
cp /root/fstab /mnt/gentoo/etc
i przekopiowac do /mnt/gentoo/etc oraz zmienic haslo roota: passwd oraz plik 
vim /etc/sudoers
uruchomic: mchroot /mnt/gentoo 
a po nim polecenia 
mount /boot
grub-mkconfig -o /boot/grub/grub.cfg
