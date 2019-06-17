# INFO

This script enables the safe-shutdown and reset buttons on Retroflag's NesPi & SuperPi cases on OSMC and Raspbian. It is basically a stripped down version of ES-generic-shutdown by cyperghost to work on OSMC and Raspbian so all credit goes to him! 

This makes the pi shutdown completely, including the fan!!!

For the original script for Retropi see:

https://github.com/crcerror/ES-generic-shutdown  
http://retroflag.com/  

# 1. Download and compile raspi-gpio or use comand below:

Raspbian:
```
sudo apt-get install raspi-gpio
```

OSMC:
```
cd /usr/src && sudo wget https://github.com/Denisuu/OSMC_NesPi-SuperPi_Safe-Shutdown/raw/master/raspi-gpio-osmc.tar.gz && tar -xvzf raspi-gpio-osmc.tar.gz && cd /usr/src/raspi-gpio && apt-get install make && make install
```
```
sudo rm -r /usr/src/raspi-gpio/ raspi-gpio-osmc.tar.gz
```

# 2. Make directory & install shutdownscript:

Raspbian:
```
mkdir /home/pi/scripts && cd /home/pi/scripts && wget https://raw.githubusercontent.com/Denisuu/OSMC_NesPi-SuperPi_Safe-Shutdown/master/multi_switch.sh && chmod +x multi_switch.sh
```
OSMC:
```
sudo mkdir /home/osmc/scripts && cd /home/osmc/scripts && wget https://raw.githubusercontent.com/Denisuu/OSMC_NesPi-SuperPi_Safe-Shutdown/master/multi_switch.sh && chmod +x multi_switch.sh
```

# 3. Edit rc.local to autostart the script:
Raspbian & OSMC:
```
sudo nano /etc/rc.local
```

Add the following line above exit 0

Raspbian:
```
/home/pi/scripts/multi_switch.sh --nespi+ & #Add this line above exit 0!
```

OSMC:
```
/home/osmc/scripts/multi_switch.sh --nespi+ & #Add this line above exit 0!
```

# 4. Install fan_shutdown script (by cyperghost):
```
cd /lib/systemd/system-shutdown/ && sudo wget https://raw.githubusercontent.com/crcerror/ES-generic-shutdown/master/shutdown_fan && sudo chmod +x shutdown_fan
```
