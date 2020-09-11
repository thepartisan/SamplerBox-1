sudo systemd-analyze critical-chain
# The time after the unit is active or started is printed after the "@" character.
# The time the unit takes to start is printed after the "+" character.

# graphical.target @14.650s
# └─multi-user.target @14.649s
#  └─ssh.service @14.497s +140ms
#    └─network.target @14.479s
#      └─dhcpcd.service @4.566s +9.910s
#        └─basic.target @4.510s
#          └─sockets.target @4.509s
#            └─triggerhappy.socket @4.508s
#              └─sysinit.target @4.504s
#                └─systemd-timesyncd.service @4.171s +331ms
#                  └─systemd-tmpfiles-setup.service @4.036s +113ms
#                    └─local-fs.target @4.023s
#                      └─boot.mount @3.954s +67ms
#                        └─systemd-fsck@dev-disk-by\x2dpartuuid-e9c38ddf\x2d01.service @3.531s +413ms
#                          └─dev-disk-by\x2dpartuuid-e9c38ddf\x2d01.device @2.871s


# Changed some settings:
echo disable_splash=1 | sudo tee -a /boot/config.txt
sudo sed -i "s|^dtoverlay|#dtoverly|g" /boot/config.txt
echo "dtoverlay=sdtweak,overclock_50=100" | sudo tee -a /boot/config.txt
echo "boot_delay=0" | sudo tee -a /boot/config.txt
echo "force_turbo=1" | sudo tee -a /boot/config.txt
echo "dtoverlay=disable-bt" | sudo tee -a /boot/config.txt
echo "dtoverlay=disable-wifi" | sudo tee -a /boot/config.txt
sudo sed -i "s|yes root|yes quiet root|g" /boot/cmdline.txt


#sudo systemctl disable dhcpcd.service
#sudo systemctl disable networking.service
#sudo systemctl disable ssh.service
sudo systemctl disable ntp.service
sudo systemctl disable dphys-swapfile.service
sudo systemctl disable keyboard-setup.service
sudo systemctl disable apt-daily.service
sudo systemctl disable wifi-country.service
sudo systemctl disable hciuart.service
sudo systemctl disable raspi-config.service
sudo systemctl disable avahi-daemon.service
sudo systemctl disable triggerhappy.service


# graphical.target @12.344s
# └─multi-user.target @12.343s
#   └─ssh.service @12.171s +171ms
#     └─network.target @12.165s
#       └─dhcpcd.service @2.474s +9.690s
#         └─basic.target @2.425s
#           └─sockets.target @2.425s
#             └─dbus.socket @2.425s
#               └─sysinit.target @2.421s
#                 └─systemd-timesyncd.service @2.224s +196ms
#                   └─systemd-tmpfiles-setup.service @2.162s +58ms
#                     └─local-fs.target @2.150s
#                       └─boot.mount @2.125s +24ms
#                         └─systemd-fsck@dev-disk-by\x2dpartuuid-e9c38ddf\x2d01.service @1.849s +265ms
#                           └─dev-disk-by\x2dpartuuid-e9c38ddf\x2d01.device @1.802s


sudo systemctl disable rpi-eeprom-update.service
sudo systemctl disable wpa_supplicant.service
sudo systemctl disable systemd-timesyncd.service

sudo systemctl disable dphys-swapfile.service
sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer
sudo systemctl disable nfs-client.target
sudo systemctl disable remote-fs.target
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable nfs-config.service

# graphical.target @12.644s
# └─multi-user.target @12.644s
#   └─ssh.service @12.470s +173ms
#     └─network.target @12.456s
#       └─dhcpcd.service @2.347s +10.108s
#         └─basic.target @2.322s
#           └─sockets.target @2.322s
#             └─dbus.socket @2.322s
#               └─sysinit.target @2.322s
#                 └─systemd-timesyncd.service @2.163s +158ms
#                   └─systemd-tmpfiles-setup.service @2.103s +53ms
#                     └─local-fs.target @2.100s
#                       └─boot.mount @2.026s +73ms
#                         └─systemd-fsck@dev-disk-by\x2dpartuuid-e9c38ddf\x2d01.service @1.751s +269m
#                           └─dev-disk-by\x2dpartuuid-e9c38ddf\x2d01.device @1.717s

sudo apt -y install dropbear && sudo sed -i "s|NO_START=1|NO_START=0|g" /etc/default/dropbear
sudo apt-get purge --yes --auto-remove openssh-server

#Install samplerbox:

echo "dtoverlay=iqaudio-dacplus" | sudo tee -a /boot/config.txt
echo "blacklist snd_bcm2835" | sudo tee /etc/modprobe.d/blacklist-sound.conf



#python3

sudo apt-get update ; sudo apt-get -y install git python3-dev python3-pip \
python3-numpy cython3 python3-smbus portaudio19-dev libportaudio2 alsa-utils \
libffi-dev python3-pbkdf2 python3-tk

sudo pip3 install rtmidi2 rtmidi-python pyaudio cffi sounddevice future wifi \
pyalsaaudio psutil serial RPi.GPIO RPLCD

git clone https://github.com/thepartisan/SamplerBox-1 SamplerBox
cd SamplerBox

python3 setup.py build_ext --inplace

sudo cp samplerbox.service  /etc/systemd/system/samplerbox.service
sudo systemctl start samplerbox.service
sudo systemctl status samplerbox.service
sudo systemctl enable samplerbox.service
