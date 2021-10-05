FROM balenalib/armv7hf-debian:buster

ENTRYPOINT []

RUN install_packages darkice curl pulseaudio-utils sox

COPY pulse-client.conf /etc/pulse/client.conf
COPY start.sh ./
COPY darkice.cfg ./
RUN curl -k https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output wait-for-it.sh && chmod +x wait-for-it.sh && \
    chmod +x /start.sh

RUN useradd -ms /bin/bash darkice
USER darkice

CMD ./start.sh
