#FROM arm32v7/debian:buster as buildbase
FROM balenalib/raspberrypi3:buster as ognbase

LABEL maintainer="R. van Twisk <github@rvt.dds.nl>"

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'APT::Get::Assume-Yes "true";\nAPT::Get::allow-remove-essential "true";' > /etc/apt/apt.conf.d/90forceyes && \
    echo 'APT::Install-Recommends "false";\nAPT::Install-Suggests "false";' > /etc/apt/apt.conf.d/90norecommends

RUN apt-get update && \
    apt-get full-upgrade &&  \ 
    apt-cache search libjpeg && \
    apt-get install ca-certificates libconfig9 librtlsdr0 libjpeg8 libfftw3-dev lynx ntpdate ntp wget && \
#    wget http://download.glidernet.org/arm/rtlsdr-ogn-bin-ARM-latest.tgz -O /opt/glidernet.tgz && \
    wget http://download.glidernet.org/rpi-gpu/rtlsdr-ogn-bin-RPI-GPU-latest.tgz -O /opt/glidernet.tgz && \
    tar --strip-components=1 -xf /opt/glidernet.tgz -C /opt && \
    chown root /opt/gsm_scan && \
    chmod a+s /opt/gsm_scan && \
    chown root /opt/ogn-rf && \
    chmod a+s  /opt/ogn-rf && \
    mknod /opt/gpu_dev c 100 0 && \
    rm -f /opt/glidernet.tgz && \ 
    curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output /wait-for-it.sh && chmod +x /wait-for-it.sh && \
    curl http://download.glidernet.org/common/WW15MGH.DAC --output /opt/WW15MGH.DAC

RUN apt-get install screen
RUN echo -e "blacklist 8192cu" > /etc/modprobe.d/blacklist-8192cu.conf && \
    echo -e "blacklist rtl2832\nblacklist r820t\nblacklist rtl2830\nblacklist dvb_usb_rtl28xxu" > /etc/modprobe.d/blacklist-rtl8xxxu.conf

COPY start.sh /
RUN chmod +x /start.sh

WORKDIR /opt
EXPOSE 8080 8081 50010
CMD /start.sh
