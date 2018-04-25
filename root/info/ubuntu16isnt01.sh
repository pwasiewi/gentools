
########################################################################################
#Nowa instalacja Ubuntu 16.04 - tylko taka pasuje do ROCm i CodeXL, które są opensource
########################################################################################
sudo apt install -y vim mc curl p7zip-full
#zaznaczyć w Oprogramowanie i Aktualizacja->Opcje Programisty->xenial-proposed
sudo apt-get install --install-recommends linux-generic-hwe-16.04 xserver-xorg-hwe-16.04 -y
sudo apt install -y docker vagrant virtualbox cmake libboost-dev uswsusp
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo apt-get update && sudo apt-get install obs-studio -y


########################################################################################
#chrome and firefox beta PPA and atom editor
########################################################################################
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo add-apt-repository ppa:mozillateam/firefox-next -y
sudo add-apt-repository ppa:webupd8team/atom -y
sudo apt-get update 
sudo apt-get install -y google-chrome-stable firefox atom uncrustify

########################################################################################
#gnome for ubuntu
########################################################################################
sudo apt dist-upgrade -y
#sudo apt install ubuntu-gnome-desktop -y

