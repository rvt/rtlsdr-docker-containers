FROM arm32v7/debian:buster-slim

LABEL maintainer="R. van Twisk <docker@rvt.dds.nl>"

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'APT::Get::Assume-Yes "true";\nAPT::Get::allow-remove-essential "true";' > /etc/apt/apt.conf.d/90forceyes && \
    echo 'APT::Install-Recommends "false";\nAPT::Install-Suggests "false";' > /etc/apt/apt.conf.d/90norecommends

RUN apt-get update &&  \
  apt-get full-upgrade &&  \ 
  apt-get install icecast2 xmlstarlet &&  \
  apt autoclean && apt clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*
  
COPY ./etc/icecast2/icecast.xml /etc/
COPY ./start.sh /

RUN chown -R icecast2 /etc/icecast2 && \
  chmod +x ./start.sh 

EXPOSE 8000

USER icecast2
CMD ./start.sh
