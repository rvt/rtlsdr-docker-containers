FROM arm32v7/debian:buster-slim

ENTRYPOINT []

RUN apt-get update && apt-get install -qy apt-utils wget && \
  wget https://flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_5.0_all.deb && \
  dpkg -i piaware-repository_5.0_all.deb && \
  apt-get update && \
  apt-get install -qy piaware && \
  apt autoclean && apt clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

COPY ./start.sh start.sh
RUN chmod +x start.sh

EXPOSE 30105
EXPOSE 30106

CMD ["/start.sh"]
