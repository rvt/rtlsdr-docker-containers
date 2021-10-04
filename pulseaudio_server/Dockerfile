FROM arm32v7/debian:buster-slim as buildbase

LABEL maintainer="R. van Twisk <github@rvt.dds.nl>"

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'APT::Get::Assume-Yes "true";\nAPT::Get::allow-remove-essential "true";' > /etc/apt/apt.conf.d/90forceyes && \
    echo 'APT::Install-Recommends "false";\nAPT::Install-Suggests "false";' > /etc/apt/apt.conf.d/90norecommends

RUN apt-get update && \
    apt-get full-upgrade &&  \ 
    apt-get install ca-certificates git-core cmake build-essential pkg-config debhelper wget udev git

WORKDIR /tmp
RUN mkdir /tmp/build


##########################################################################################
FROM buildbase as ladspa
WORKDIR /tmp
RUN cd /tmp/build && \
    git clone https://github.com/werman/noise-suppression-for-voice && \
    cd noise-suppression-for-voice  && \
    cmake -Bbuild-x64 -H. -DCMAKE_BUILD_TYPE=Release && cd build-x64 && make && \
    ls -ial

##########################################################################################
FROM arm32v7/debian:buster-slim

LABEL maintainer="R. van Twisk <github@rvt.dds.nl>"

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'APT::Get::Assume-Yes "true";\nAPT::Get::allow-remove-essential "true";' > /etc/apt/apt.conf.d/90forceyes && \
    echo 'APT::Install-Recommends "false";\nAPT::Install-Suggests "false";' > /etc/apt/apt.conf.d/90norecommends

COPY --from=ladspa /tmp/build/noise-suppression-for-voice/build-x64/bin/ladspa/ /ladspa/

RUN apt-get update && \
    apt-get full-upgrade &&  \ 
    apt-get install pulseaudio pulseaudio-utils pulseaudio-module-zeroconf dbus dbus-x11 procps sox vim && \
    apt autoclean && apt clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# airband sends to default sink
# module-rtp-send picks up from default sink called rtp to rtp.monitor

RUN echo "\
set-default-sink denoised\n\
set-default-source input\n\
load-module module-native-protocol-tcp auth-anonymous=true\n\
load-module module-null-sink sink_name=denoised\n\
load-module module-rtp-send source=denoised.monitor\n\
load-module module-ladspa-sink sink_name=input sink_master=denoised label=noise_suppressor_stereo plugin=/ladspa/librnnoise_ladspa.so control=0\n\
" >> /etc/pulse/default.pa
RUN sed -i "/$load-module module-console-kit/s/^/#/g" /etc/pulse/default.pa
RUN echo "default-fragments = 5\n\
default-fragment-size-msec = 10" >> /etc/pulse/daemon.conf



RUN mkdir -p /var/run/pulse/.config/pulse && chown -R pulse:pulse /var/run/pulse/ && mkdir -p /var/run/dbus/ && chown -R pulse:pulse /var/run/dbus/

WORKDIR /var/run/pulse/
COPY start.sh ./
RUN chmod +x ./start.sh

USER pulse
CMD ./start.sh
