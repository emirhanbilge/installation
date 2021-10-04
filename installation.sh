#!/bin/bash


echo 1234 | sudo -S su

### Pi arayüz olmayan kısımda burası çalıştırılarak oraya gidilecek
##mkdir Desktop
##cd Desktop
##mkdir EbbScripts
##cd EbbScripts

echo "Git is installed ..."
sudo apt-get install git -y

now=$(date)
echo "date $now - LogFileEb " >> /home/pi/log.txt



#####################################################  Klasörlerin Oluşturulması ##################################
if [ ! -d "/home/pi/Desktop"]
then
echo "Desktop yok oluşuruluyor ... "
cd /home/pi/
sudo mkdir Desktop
else
echo "Desktop var "
fi


cd Desktop

if [ ! -d "/home/pi/Desktop/EbbScripts"]
then
echo "EbbScripts yok oluşuruluyor ... "
cd /home/pi/Desktop
sudo mkdir EbbScripts
else
echo "EbbScripts var "
fi

cd EbbScripts


path="/home/pi/Desktop/EbbScripts" 




####################################################################################################################









#########################################   PORT FORWARD CRONTAB   #########################################
sudo echo "sudo iptables -t nat -A PREROUTING -p tcp --dport 502 -j REDIRECT --to-ports 5020" > portForward.sh
sudo crontab -l > crontab_new
echo "@reboot /home/pi/Desktop/EbbScripts/portForward.sh" >> crontab_new
crontab crontab_new
rm crontab_new
sudo chmod +x /home/pi/Desktop/EbbScripts/portForward.sh
echo "Port forwerding "
sudo ./portForward.sh
echo "Port is ok "
#############################################################################################################







#echo -ne 1 | sudo crontab -e


################################### Network Ayarlarının Yedeklenmesi
mkdir backupNetwork
cp /etc/dhcpcd.conf /home/pi/Desktop/EbbScripts/backupNetwork
cp /etc/network/interfaces /home/pi/Desktop/EbbScripts/backupNetwork
cp /etc/hostapd/hostapd.conf  /home/pi/Desktop/EbbScripts/backupNetwork
cp /etc/dnsmasq.conf /home/pi/Desktop/EbbScripts/backupNetwork
########################################################################



##################################  Python requirements yüklenmesi ve numpyın çalışmasının sağlanması   ##################################
echo "Start EB Script ..."
echo "Update Check "
sudo apt-get update && sudo apt-get -y upgrade
echo "Update Ok" 
echo "Installing Numpy"
sudo apt-get libatlas3-base -y
sudo apt-get install python3-numpy
echo "Numpy installed"
echo "Installing Requirements ..." 
sudo apt-get -y install python3-pip
sudo apt-get install python3-netifaces
sudo pip3 install -r /home/pi/Desktop/EbbScripts/requirements.txt 
sudo pip install numpy --upgrade
sudo apt-get install libatlas-base-dev -y
#############################################################################################################################################





############################################### Temel Dosya yapılarımızın oluşması ve derlenmesi ############################################
# Değiştirdiğimiz kütüphanelerin yenilenmesi ve yenilendikten sonra silinmesi , resetlense bile 1 kere çalıştırmamız yeterli (Sonraki resetlerde çalışması sorun olmamamakla birlikte gerek de yoktur)
sudo git clone https://github.com/emirhanbilge/autoChangeLibraryFile.git
sudo git clone https://github.com/emirhanbilge/ModbusScd.git
cd autoChangeLibraryFile
echo 1234 | sudo -S su
echo " Auto Import Başlatılıyor ... "
sudo python3 autoImport.py
cd ..
sudo rm -r /home/pi/Desktop/EbbScripts/autoChangeLibraryFile # auto import tek seferlik bir şey olduğu için yükledikten sonra kaldırılıyor
echo "Tek seferlik auto import bitti "
# Network dosyalarının oluşturulması 
sudo git clone https://github.com/emirhanbilge/Network.git   # Temel Netwok dosyamız
cd Network
# First Setup 
sudo git clone https://github.com/emirhanbilge/WebServer.git # Otomatik mail ve dosya indirmenin olduğu sunucumuz
sudo git clone https://github.com/emirhanbilge/FirstSetup.git # FirstSetupın oluşması 
# Hotspotun derlenmesi
sudo chmod +x /home/pi/Desktop/EbbScripts/Network/hotspot.sh
sudo chmod +x /home/pi/Desktop/EbbScripts/Network/backupNetwork.sh
sudo chmod +x /home/pi/Desktop/EbbScripts/Network/modbusCrontabCreate.sh
sudo chmod +x /home/pi/Desktop/EbbScripts/Network/FirstSetup/netSet.sh
sudo chmod +x /home/pi/Desktop/EbbScripts/Network/running.sh # modbusu çalıştıracak kısmın derlenmesi
sudo ./hotspot.sh # ayarlamaları yapıp reboot yapacak
##################################################################################################################################################


