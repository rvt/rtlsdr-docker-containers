FROM arm32v7/debian:buster-slim

LABEL maintainer="R. van Twisk <github@rvt.dds.nl>"

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'APT::Get::Assume-Yes "true";\nAPT::Get::allow-remove-essential "true";' > /etc/apt/apt.conf.d/90forceyes && \
    echo 'APT::Install-Recommends "false";\nAPT::Install-Suggests "false";' > /etc/apt/apt.conf.d/90norecommends

RUN apt-get update && \
    apt-get full-upgrade &&  \ 
    apt-get install pulseaudio-utils darkice sox curl && \
    apt autoclean && apt clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* && \
    mkdir /darksice

RUN curl -k https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output wait-for-it.sh && chmod +x wait-for-it.sh
COPY pulse-client.conf /etc/pulse/client.conf
COPY start.sh darkice.cfg ./
RUN chmod +x ./start.sh

CMD ./wait-for-it.sh icecast2:8000 && ./wait-for-it.sh pulseaudio_server:4713 && ./start.sh
