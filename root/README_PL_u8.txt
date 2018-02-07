Witam na LIVEUSB!

Aby uruchomic liveusb nalezy je zbootowac z wlaczona opcja w BIOSIE boot from
dvd lub usb. 
Wyrozniamy dwa rodzaje operacji 

I. INSTALACJA Z OFICJALNEGO LIVEDVD/USB NA VIRTUALBOX

##############################################################
#1etap
sudo su -
#Skrypty do screencastów o sprawnej instalacji gentoo https://goo.gl/Ao9sUU
#STARSZA WERSJA skryptów: wget -c https://goo.gl/zbNuuu  -O../config.txz
#wget -c https://codeload.github.com/pwasiewi/gentools/tar.gz/v0.7  -O../config.txz
#NOWSZA WERSJA skryptów: 
wget -c https://goo.gl/GctckJ  -O../config.txz
cd / && tar Jxvf config.txz && cd
v a p #edytuj settings chroot na /dev/sda5 
#UWAGA to dla dysku z wirtualboxa
#uwaga na symbol /DEV/SDA
#czy opisuje on wlasciwy dysk
#------------------------------------------------------------
#-POCZATEK-formatowanie dysku TYLKO w virtualboxie ----------
parted -s /dev/sda mklabel gpt
parted /dev/sda mkpart primary fat32 1MiB 5MiB
parted /dev/sda mkpart primary fat32 5MiB 205MiB
parted /dev/sda mkpart primary ext4 205MiB 405MiB
parted /dev/sda mkpart primary linux-swap 405MiB 1405MiB
parted /dev/sda mkpart primary ext4 1405MiB 100%
parted /dev/sda set 1 bios on
mkfs.ext4 /dev/sda3
mkswap /dev/sda4
swapon /dev/sda4
mkfs.ext4 /dev/sda5
#-KONIEC-----------------------------------------------------
#------------------------------------------------------------
v a f #sciagnij stage3/4
v a 1 #rozpakuj stage3/4, portage i popraw make.conf, vim
v a e #chroot na nowy system gentoo
#------------------------------------------------------------
#-POCZATEK po v a e wpisz komendy (VirtualBox)---------------
#edytuj fstab
#vim /etc/fstab
mount /dev/sda3 /mnt #montuj partycje boot
cp -a /boot/* /mnt   #i skopiuj do niej oryginalny /boot
umount /mnt
mount /boot
grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda
passwd #ZMIANA HASLA NA ROOTA NA WLASNE
#-KONIEC - po v a e wpisz komendy (VirtualBox)---------------
#------------------------------------------------------------
#REBOOT i dalsza instalacja np. plasma-meta

##############################################################
#2etap podmiana gcc na nowsze i kompilacja boost
v a 2host
##update na nowszy gcc - etap dodatkowy
##kompilacja trwa 30min
#vex sys-devel/gcc
#OLDGCC=`gcc-config -c | cut -d'-' -f 5`
#e gcc
#gcc-config -l
#gcc-config 2
#. /etc/profile
#env-update
#fix_libtool_files.sh ${OLDGCC}
#e libtool n


##############################################################
#3etap uaktualnienie systemu z odblokowanymi flagami USE
v a 3host
##kompilacja trwa 2h
#sed -i 's/#USE="${USE} video/USE="${USE} video/g' /etc/portage/make.conf
#sed -i 's/#USE="${USE} gimp/USE="${USE} gimp/g' /etc/portage/make.conf
#sed -i 's/#USE="${USE} tools/USE="${USE} tools/g' /etc/portage/make.conf
#sed -i 's/bindist/-bindist/g' /etc/portage/make.conf
#sed -i 's/-X\ /X\ /g' /etc/portage/make.conf
#e w #emerge -uND world  - upgrade world - 214 pakietow w ponad 2h


##############################################################
#4etap instalujemy git i laymana do dodatkowych pakietow
v a 4host
##kompilacja trwa 14min
#e u gpm app-misc/mc ntp
#/etc/init.d/ntp-client start
#/etc/init.d/gpm start
#rc-update add gpm default
#veu "dev-libs/libgpg-error static-libs"
#veu "dev-libs/lzo static-libs"
#veu "dev-libs/libgcrypt static-libs"
#vex sys-libs/readline
#vex app-shells/bash
#e n readline #emerge --nodeps readline 
#emerge @preserved-rebuild
#vex dev-python/ssl-fetch
#e u layman #okolo 32 pakietow po etapie 3 aktualizacji 238 pakietow
##e u dev-vcs/git #juz zainstalowany przez laymana

##############################################################
#5etap dodatkowe pakiety i update systemu po dodaniu overlayow
v a 5host
##kompilacja trwa 14min po etapie 3 aktualizacji
#vex sys-fs/mdadm
#vex sys-fs/squahsfs-tools
#vex net-analyzer/xprobe
#vex app-admin/pass
#vex dev-python/pymountboot
#vex app-admin/eclean-kernel
#vex app-portage/diffmask
#vex app-portage/install-mask
## https://wiki.gentoo.org/wiki/Recommended_applications
## https://wiki.gentoo.org/wiki/Recommended_tools
## https://wiki.gentoo.org/wiki/Useful_Portage_tools
#e u rlwrap most dvtm pass pfl pybugz elogv eclean-kernel diffmask flaggie install-mask portpeek smart-live-rebuild ufed gpytage net-misc/curl pydf ncdu acpi acpitool htop atop lsof iotop iftop squashfs-tools sudo #suspend p7zip sg3_utils testdisk logrotate gentoolkit gentoolkit-dev f2fs-tools 
#curl ix.io/client > /usr/local/bin/ix
#chmod +x /usr/local/bin/ix
#emaint -A sync
#sed -i 's/^check_official : Yes/check_official : no/' /etc/layman/layman.cfg
#layman -L
#layman -a kde
#layman -a x11
#layman -a sabayon 
#eix-update
#e w #emerge -uND world  - upgrade world - kompilacja max 10min 

##############################################################
#6etap kompilacja pakietu qtwebkit na jednym rdzeniu 
v a 6host
##kompilacja trwa 1h
#veu "net-dialup/ppp ipv6"
#veu "kde-plasma/plasma-desktop legacy-systray"
#veu "media-plugins/alsa-plugins pulseaudio"
#echo 'CFLAGS=""' > /etc/portage/env/empty1core
#echo 'CXXFLAGS=""' >> /etc/portage/env/empty1core
#echo 'LDFLAGS=""' >> /etc/portage/env/empty1core
#echo 'MAKEOPTS="-j1"' >> /etc/portage/env/empty1core
#echo "dev-qt/qtwebkit empty1core" >> /etc/portage/package.env/moje.env
#e qtwebkit #45 pakietow 60min
#echo 'Jak nie skompiluje sie qtwebkit, uzyc kompilacji na jednym rdzeniu:'
#echo 'MAKEOPTS="-j1" e qtwebkit'

##############################################################
#7etap caly desktop plasma min. 80min
v a 7host
##kompilacja trwa 85min
#echo "kde-plasma/plasma-desktop empty1core" >> /etc/portage/package.env/moje.env
#e u plasma-desktop #243 nowe pakiety 56min
#e u plasma-meta    #54 pakiety 13min
#e u konsole setxkbmap kde-apps/dolphin xdpyinfo xrandr xkill xterm alsamixergui media-video/plasma-mediacenter pavucontrol gparted freetype media-fonts/liberation-fonts           #42 pakietow 12min
##infinality use flag
#eselect infinality set infinality
#eselect lcdfilter set infinality-sharpened

##############################################################
#8etap dodatkowe pakiety, x11 virtualbox, nowy uzytkownik
v a 8host
##kompilacja trwa 1h 
##plus czas na upgrade po usunieciu zbednych flag use wstawionych veu
##sieci
#veu "dev-libs/nss utils"
#e u x11-misc/bumblebee feh lm_sensors xsensors lft nload yersinia vnstat xprobe wavemon geoipupdate qpdfview scite iptraf-ng libreswan openvpn quagga #27 pakietow 4min
#uzytkowe
#vex www-client/firefox-bin
#vex app-emulation/lxc
#vex app-emulation/docker
#vex sys-process/criu
#vex app-emulation/containerd
#vex app-emulation/runc
#e u firefox-bin app-emulation/docker lxc #12 pakietow 5min
#usermod -aG docker guest
##e w #6 pakietow 15min
#vex net-libs/nodejs
#vex dev-libs/libuv
#vex app-admin/mongo-tools 
#vex dev-db/mongodb #na razie rezygnuje z kompilacji mongodb, gdyz trzeba na 1 rdzeniu
#echo "dev-db/mongodb empty1core" >> /etc/portage/package.env/moje.env
#e u cdrtools dvd+rw-tools libisoburn R octave nodejs opera #67 pakietow 30min
#vex x11-drivers/xf86-video-virtualbox
#e u =x11-drivers/xf86-video-virtualbox-5.1.6
#echo "jesli blad kompilacji virtualbox drivera, to nalezy poprawic kod wykorzystujac ebuild wykonujacy instalacje etapami:"
#echo "ebuild /usr/local/portage/x11-drivers/xf86-video-virtualbox/xf86-video-virtualbox-5.1.6.ebuild compile"
#echo "ebuild /usr/local/portage/x11-drivers/xf86-video-virtualbox/xf86-video-virtualbox-5.1.6.ebuild install"
#echo "ebuild /usr/local/portage/x11-drivers/xf86-video-virtualbox/xf86-video-virtualbox-5.1.6.ebuild qmerge"
##po usunieciu za pomoca viu zbednych ograniczen z package.use/moje.use
##kompilacja 14 pakietow trwa 1h, gdyz jest tam webkit-gtk
##potem nalezy dodac uzytkownika
#useradd -m -g users guest
##passwd guest
#echo 'exec startkde' > /home/guest/.xinitrc
#chown -R guest:users /home/guest/
#usermod -aG wheel guest
#usermod -aG audio guest
#usermod -aG video guest
#echo Wykonaj: passwd guest
##vex app-text/calibre
##vex media-gfx/gimp
##e u calibre gimp vlc mplayer
##e u skype google-chrome steam-launcher ghc go blender 
##############################################################

II. INSTALACJA LUB URUCHOMIENIE WLASNEGO GENTOO USB

Na wlasnym komputerze nalezy wczesniej wydzielic (np. za pomoca Partition
Magic, gdisk) trzy male partycje 10MB, 10MB, 100MB oraz wolna partycje o
rozmiarze okolo 20GB (sformatowac ext4, jesli dla ssd to z parametrami stride,
stripe-width).
Symbole partycji rodzajow w gdisku: EF00, EF02, 8300, 8300 czyli 2 dla boota
EFI i dwie dla systemu w tym pierwsza dla kerneli.
Dla pewnosci wydzielic jeszcze mozna partycje swap o rozmiarze co najmniej polowy pamieci fizycznej RAM zamontowanej w komputerze.

Po uruchomieniu liveusb po komendzie sg_map zorientowac sie, jak nazywa sie
dysk z partycja kilkugigabajtowa, komenda gdisk /dev/sd?? znalezc ta partycje (ALE NIE POMYLIC SIE), sformatowac ja (TA ODDZIELONA) systemem plikow np.  

Zamontowac glowna partycje /dev/sd? na katalogu /mnt/gentoo poleceniem:
montuj-dysk /dev/sd? 
lub jesli dysk ssd:
montuj-ssd /dev/sd? 
albo jesli dysk samsung evo:
montuj-evo /dev/sd? 

Zamontowac partycje boot na kernele:
mount /dev/sd? /mnt/key
i skopiowac kernele
cp -a /boot/* /mnt/key

Edytowac dodajac poprzednio sformatowane partycje pliki konfiguracyjne np.:
vim fstab 
cp -a fstab inittab /mnt/gentoo/etc

mchroot /mnt/gentoo
mount /boot
grub-install /dev/sdx
grub-mkconfig -o /boot/grub/grub.cfg

Zmieniamy haslo roota: passwd 

Po ponownym zbotowaniu z twardego dysku, w menu systemow wybor Gentoo, 
mozna sie zalogowac na roota i dodac nowego uzytkownika i jego haslo:
adduser -m nazwa_loginu
passwd nazwa_loginu

Potem po podlaczeniu do sieci - jesli juz nie podlaczylo automatycznie - (konfiguracja w /etc/conf.d/net) poprzez komende
/etc/init.d/net.eth0 restart
lub
/etc/init.d/net.enp0s3 restart
wykonujemy polecenia (wyjasnienie ponizej):
emerge --sync
itd.... ;)
Jesli w /etc/portage/repos.conf sa overlaye dla laymana > 2.2.2
layman -a kde
layman -a stuff
layman -a sabayon
layman -a toolchain;

Otrzymujemy system gotowy do dzialania.

##############################################################
UZYTKOWANIE GENTOO

emerge --sync
Sprowadza drzewo portage czyli nazwy pakietow (dokladnie plikow ebuild) i 
ich zaleznosci

layman -L
Sprowadza liste ebuildow

layman -a kde
layman -a x11
layman -a stuff
layman -a sabayon
layman -a toolchain;
Sprowadza przykladowe overlay'e 

Updatowanie eksperymentalnych list zainstalowanych na lokalnym komputerze
layman -s ALL
lub wszytskiego
emaint -A sync

layman -a nazwa_overlayu - dodaje jedna liste (overlay) ebuildow zamieszczonych na gentoo.org przez entuzjastow danych programow pragnacych testowac ich najnowsze opcje

layman -L
Wypisanie wszystkich list eksperymentalnych zamieszczonych na gentoo.org

layman -l 
Wypisanie eksperymentalnych list ebuildow zainstalowanych na lokalnym
komputerze

vim /etc/make.conf
Mozna edytowac tam flagi procesora, ale przede wszystkim flagi systemu portage
wystepujace po slowie USE="..." w cudzyslowie np. USE="gnome kde" czyli
skompilowac programy ze wsparciem dla Gnome i KDE

vim /etc/portage/package.use/package.use
Tutaj flagi systemu portage mozna przypisac do poszczegolnych programow, jesli
roznia sie od flag o globalnym zasiegu z pliku /etc/make.conf

vim /etc/portage/package.keywords/package.keywords
Tu dodaje sie pakiety, ktore sie chce skompilowac z kodow zrodlowych wersji
deweloperskich czyli z reguly prawie lub najnowszych. Jesli zalezy komus tylko
na stabilnosci to radze usunac jak najwiecej pakietow z tego pliku, ale komu
na tym zalezy, kiedy uzywa Gentoo...

vim /etc/portage/profile/package.provided
Zamieszczone tu tytuly pakietow nieobecnych, ktore "oszukuja"
system, ze sa w nim nadal obecne lub powoduja brak aktualizacji 

emerge -uND world 
Updatuje po sprowadzeniu najnowszego drzewa za pomoca wczesniejszego emerge --sync pakiety do nowszych wersji i ewentualnie zmienionych flag systemowych w /etc/make.conf i /etc/portage/package.use

emerge -fuN world 
Sprowadza najpierw kody zrodlowe, potem trzeba wpisac emerge -uN world, ale
polaczenie sieciowe jest juz zbedne, kompilacje wykonaja sie off-line, gdyz
wszystko co potrzebne do nich zostalo sprowadzone opcja -f

emerge -uNp world
Wypisuje nazwy programow do skompilowania bez samego kompilowania

emerge -uNpv world
Wypisuje nazwy programow do skompilowania bez samego kompilowania wraz z
flagami systemu portage, ktore zostana uzyte przy kompilacji programu

emerge -uNpvt world
Wypisuje nazwy programow do skompilowania bez samego kompilowania wraz z
flagami systemu portage, ktore zostana uzyte przy kompilacji programu oraz
hierarchia pakietow zobrazowana w postaci wciec - semi-drzewa tekstowego 

emerge -e world
Rekompiluje od nowa kazdy zainstalowany program

emerge liquorix-sources 
Sprowadza kod zrodlowy liquorix-sources
Osobno sprowadzamy plik konfiguracyjny .config
lub generujemy w zaleznosci od potrzeb w /usr/src/linux:
make defconfig; make kvmconfig
