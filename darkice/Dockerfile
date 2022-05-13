FROM arm32v7/alpine:3.15.4 as darkicebuild

# https://downloads.sourceforge.net/project/darkice/darkice/1.3/darkice-1.3.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fdarkice%2Ffiles%2Fdarkice%2F1.3%2Fdarkice-1.3.tar.gz%2Fdownload&ts=1604235304

RUN apk add --no-cache fftw autoconf automake faac-dev lame-dev pulseaudio-dev alsa-lib-dev libvorbis-dev curl git \
    bash make gcc g++ linux-headers binutils-gold gnupg libstdc++ tar xz wget patch libtool && \
    wget https://github.com/rafael2k/darkice/releases/download/v1.4/darkice-1.4.tar.gz -O /opt/darkice.tar.gz


RUN mkdir /opt/darkice/ && \
    tar --strip-components=1 -xf /opt/darkice.tar.gz -C /opt/darkice && \
    cd /opt && git clone https://github.com/chalos/libaacplus

RUN cd /opt/libaacplus && \
    ./autogen.sh --enable-shared --enable-static && \
    make && \
    make install

RUN cd /opt/darkice && ./configure && make 

FROM arm32v7/alpine:3.15.4

COPY --from=darkicebuild /opt/darkice/src/darkice /
COPY --from=darkicebuild /usr/local/lib /usr/local/lib
COPY pulse-client.conf /etc/pulse/client.conf
COPY start.sh darkice.cfg ./
RUN apk add --no-cache curl pulseaudio bash sed lame faac coreutils shadow && \
    curl -k https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output wait-for-it.sh && chmod +x wait-for-it.sh && \
    chmod +x /start.sh && \
    useradd -ms /bin/bash darkice

USER darkice

CMD ./start.sh
