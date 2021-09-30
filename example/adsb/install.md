## rtlsdr_dump1090
in docker-compose.yml fill in the values under environment


## piaware

Create an account on flightaware.
Edit piware.conf and fill in your flightaware id in FEEDER_ID
The feeder ID should be a UUID

## ADSBExchange

With ADSBExchange you don´t have to create an account.
Under adsbexchange-mlat fill in your long/lat and altitude (feet) RECEIVER_NAME can be your name or a fantacy name

## adsbhub

Register your name
Create a new station
Fill in : Long/Lat
Feeder type : PiAware
Protocol : SBS
Station Mode : client
Add station external Host IP (get it with https://www.whatsmyip.org)
Note: No need to change configurations here


## OpenSky
 - Create an opesky account
 - Fill in your username in opensky-10-debconf.conf
 - fille in your serial in opensky-05-serial.conf
 - Note: Not sure yet how to get the serial easy

## FlightRadar 24
Create an account
Fill in your fr24feed id in fr24feed.ini (not sure anymore how to create a feed ID)


