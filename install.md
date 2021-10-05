# RTL-SDR Restreamer for Raspberry PI

With flasshtool install GUI-less debian

- Enable ssh on raspberry by creating a ssh file in the boot directry

- Startup the PI and login, execute the following commands

```bash
echo "blacklist r820t" | sudo tee -a /etc/modprobe.d/dvb-blacklist.conf
echo "blacklist rtl2832" | sudo tee -a /etc/modprobe.d/dvb-blacklist.conf
echo "blacklist rtl2830" | sudo tee -a /etc/modprobe.d/dvb-blacklist.conf
echo "blacklist dvb_usb_rtl28xxu" | sudo tee -a /etc/modprobe.d/dvb-blacklist.conf
sudo apt-get update
sudo apt-get upgrade
sudo apt-get full-upgrade 
sudo apt purge xserver* gnome* qt5* vlc* lightdm* x11* raspberrypi-ui-mods 
sudo apt purge golang-docker-credential-helpers
sudo apt-get install docker docker-compose ntp
sudo apt autoremove
```

## Setup WIFI (optionallY)

Edit `/etc/wpa_supplicant/wpa_supplicant.conf`
```bash
echo "
country=NL
network={
    ssid="SSID"
    psk="WIFI_PASSWORD"
}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
```

## Power off HDMI

Under investigation `vcgencmd display_power 0 3` to turn off HDMI0, or `vcgencmd display_power 0 7` to turn off HDMI1.

```bash
echo "/usr/bin/tvservice -o" | sudo tee -a /etc/cron.daily/poweroffhdmi
sudo chmod +x /etc/cron.daily/poweroffhdmi
```


## Time
Make sure time is running correctly, otherwise streams might disconnect from the client

## Reduce flash drive wear out

Execute the below command

```bash
echo "# To re-enable logging rename this file to nolog._conf and issue 'systemctl restart rsyslog'
*.*     ~" | sudo tee /etc/rsyslog.d/nolog.conf
sudo systemctl restart rsyslog
```

## Add pi user to docker group

```bash
sudo usermod -a -G docker pi
```

## Install watchdog (Optionally)

Enable watchdog and test for high load and if we can ping a network interface, by default your gateway

```bash
sudo apt-get install watchdog
echo "dtparam=watchdog=on" | sudo tee -a /boot/config.txt
echo 'watchdog-device = /dev/watchdog' | sudo tee -a /etc/watchdog.conf
echo 'watchdog-timeout = 15' | sudo tee -a /etc/watchdog.conf
echo 'max-load-1 = 24' | sudo tee -a /etc/watchdog.conf
DEFAULTGW=$(ip route show 0.0.0.0/0 | awk '{print $3}') && echo "ping = $DEFAULTGW" | sudo tee -a /etc/watchdog.conf
sudo reboot
```

## Kalibration

Get the calibration/correction parameter.
For this the project kalibrate is installed : https://github.com/steve-m/kalibrate-rtl
The goal is to get the diviation in PPM of your receiver, so when you tel airband to listen to a specific frequency, it knows hot to tune your SDR correctly compemnsated for the error in it's crystals.

```bash
docker run -it --entrypoint bash --privileged -v /dev/bus/usb:/dev/bus/usb rvantwisk/rtlsdr_airband:202110042022
root@9b80749a30df:/# kal -v -s 900
Found 1 device(s):
  0:  Generic RTL2832U OEM
    chan:    8 (936.6MHz + 19.336kHz)    power:  199429.91
...
...
# Pick the channel, in this case 8 that kal found
...
GSM-900:
    chan:    3 (935.6MHz + 28.670kHz)    power:  134330.98
root@2806dd73e2e4:/# kal -v -c 8
Found 1 device(s):
  0:  Generic RTL2832U OEM
...
...
Using GSM-900 channel 8 (936.6MHz)
Tuned to 936.600000MHz (reported tuner error: 0Hz)
	offset   1: 19331.63
	offset   2: 19325.42
...
```

Fill in the value under `correction` in `docker-compose.yml`, this the above coe CORRECTOIN would be 19 (they are part per million)

## Start Airband

copy the directory `example` to one of your raspberry’s, configure the passwords under icecast2 in `docker-compose.yml` and the station you want to listen to in `rtl_airband.conf`, then execute `docker-compose up`.

Feed should be up and you should beable to listen to your feed here : [http://<IP RASPBERRY>:8000](http://<IP RASPBERRY>:8000)

If you want to stream to an external iceast you can use `darkice.cfg`, then you must enable this in `docker-compose.yml`
under the pulse2icecast setting.

Note: You will have to convert the 8.33Khz 'channels' to real frequency, you can do that with [Frequency Converter](https://radioreferenceuk.co.uk/airband-8.33khz-converter.php?channel=).
Just fill in the 'frequency' and it will convert it to the frequency you have to fill in into rtl_airband.conf.



## If you need to inspect a container

If you need to inspect something in the container you can use this:

First run

```bash
pi@raspberrypi:~ $ docker ps
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                    NAMES
d03d3b8dc13f        rvantwisk/rtlsdr_airband      "/usr/bin/entry.sh /…"   8 minutes ago       Up 8 minutes                                 atis_rtlsdr_airband_1
141cfa940eb4        rvantwisk/pulse2icecast       "/usr/bin/entry.sh /…"   8 minutes ago       Up 8 minutes                                 atis_pulse2icecast_1
5154a2527fa7        rvantwisk/pulseaudio_server   "/usr/bin/entry.sh /…"   8 minutes ago       Up 8 minutes        0.0.0.0:4713->4713/tcp   atis_pulseaudio_server_1
ac775f774068        rvantwisk/icecast2            "/usr/bin/entry.sh /…"   45 minutes ago      Up 8 minutes        0.0.0.0:8000->8000/tcp   atis_icecast2_1
pi@raspberrypi:~ $
```

Then enter the container:

```bash
docker exec -it -u root atis_pulseaudio_server_1 bash
docker exec -it -u root adsb_nginx_1 bash
docker exec -it -u root atis_darkice_1 bash
docker exec -it -u root atis_icecast2_1 bash
docker exec -it -u root atis_ffmeg_pulse2iceffmpeg_1 bash
```

To start any other container if you just need to do something else

```bash
docker run -it --entrypoint bash balenalib/armv7hf-debian 
docker run -it --entrypoint bash rvantwisk/darkice
docker run -it --entrypoint bash d947efbeadb7

```

