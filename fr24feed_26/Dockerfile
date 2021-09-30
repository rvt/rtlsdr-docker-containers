FROM arm32v7/debian:buster-slim

RUN apt-get update && apt-get install -qy curl binutils && \
    apt autoclean && apt clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* && \
    curl -k https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output wait-for-it.sh && chmod +x wait-for-it.sh && \
    curl --output /tmp/fr24feed.deb https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_1.0.26-9_armhf.deb

COPY ./start.sh start.sh

RUN ar x /tmp/fr24feed.deb && \
    tar xzvf data.tar.gz && \
    touch /var/log/fr24feed.log && \
    rm -Rv /etc/cron.d/fr24feed_updater && \
    rm -Rv usr/share/fr24/licences/ && \
    chmod +x start.sh && \
    rm -Rv /etc/systemd/system/fr24feed.service && \
    rm -Rv /etc/fr24feed.ini && \
    rm -Rv /etc/udev/rules.d/rtl-sdr.rules

CMD ["/start.sh"]

