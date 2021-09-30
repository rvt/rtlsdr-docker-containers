FROM arm32v7/debian:buster-slim

RUN apt-get update && apt-get install -qy ntp curl binutils xz-utils && \
    apt autoclean && apt clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* && \
    curl -k --output wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x wait-for-it.sh && \
    curl -k --output /tmp/opensky.deb https://opensky-network.org/files/firmware/opensky-feeder_latest_armhf.deb

RUN ar x /tmp/opensky.deb && \
    tar xvf data.tar.xz && \
    rm -Rv /tmp 

COPY ./start.sh start.sh
RUN chmod +x start.sh

CMD ["/start.sh"]

