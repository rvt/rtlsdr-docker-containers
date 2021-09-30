echo "Starting dump1090-fa"
#/usr/bin/dump1090-fa --quiet --gain -10 --max-range 360 --fix --lat $LATITUDE  --lon $LONGITUDE --interactive --net --forward-mlat --ppm $CORRECTION  --json-location-accuracy 1 --write-json '/dump1090data' > /dev/null
#/usr/share/dump1090-fa/generate-wisdom

# Use a machine-specific wisdom file if it exists
if [ -f /wisdom.local ];
then
  RECEIVER_OPTIONS="${RECEIVER_OPTIONS} --wisdom /wisdom.local"
fi

if [ -z "$REDIRECT" ];
then
/usr/bin/dump1090-fa ${RECEIVER_OPTIONS} --device-index 0 --gain -10 --fix --lat $LATITUDE --lon $LONGITUDE --ppm $CORRECTION --net-bo-port 30005 --max-range 360 --net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104 --net-bo-port 30005 --json-location-accuracy 1 --write-json '/dump1090data' > /dev/null
else
/usr/bin/dump1090-fa ${RECEIVER_OPTIONS} --device-index 0 --gain -10 --fix --lat $LATITUDE --lon $LONGITUDE --ppm $CORRECTION --net-bo-port 30005 --max-range 360 --net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104 --net-bo-port 30005 --json-location-accuracy 1 --write-json '/dump1090data'
fi


sleep 5
