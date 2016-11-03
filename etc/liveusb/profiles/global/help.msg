Witam na dysku LIVECD z wykladu ISO lub zarzadzania baza danych PostgreSQL!
INSTALACJA LUB URUCHOMIENIE GENTOO 
Aby uruchomic livecd nalezy je zbootowac z wlaczona opcja w BIOSIE boot from
cdrom lub ustawic usb disk jako pierwszy w kolejce dysków twardych. 
Na wlasnym komputerze nalezy wczesniej wydzielic trzy partycje np. za pomoca gdisk wolna partycje o rozmiarze 10GB i druga mala partycje boot ok. 30MB i umieszczenia tam kernelu linuxa oraz partycje swap o rozmiarze co najmniej polowy pamieci fizycznej RAM.
Po uruchomieniu livecd po komendzie sg_map zorientowac sie, jak nazywa sie odpowiedni dysk, komenda fdisk /dev/sd?? z wlasciwa ta partycje (ALE NIE POMYLIC
SIE) pozwala na oznaczenie jej jako partycji linux lub linux swap (podkomendy l i t).
Zamontowac glowna partycje /dev/sd?? na katalogu /mnt/gentoo poleceniem:
Zamontowac partycje z boot kernelem:
mount /dev/sdxx /mnt/key
