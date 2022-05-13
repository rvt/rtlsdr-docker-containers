FROM balenalib/raspberrypi3:buster as buildbase

LABEL maintainer="R. van Twisk <github@rvt.dds.nl>"

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'APT::Get::Assume-Yes "true";\nAPT::Get::allow-remove-essential "true";' > /etc/apt/apt.conf.d/90forceyes && \
    echo 'APT::Install-Recommends "false";\nAPT::Install-Suggests "false";' > /etc/apt/apt.conf.d/90norecommends

RUN apt-get update && \
    apt-get full-upgrade &&  \ 
    apt-get install ca-certificates git-core cmake build-essential pkg-config debhelper wget udev git

WORKDIR /tmp
RUN mkdir /tmp/build

#RUN echo "deb http://archive.raspberrypi.org/debian/ buster main" > /etc/apt/sources.list.d/raspi.list


############################################################################################################################################
# Build dump1090-fa 
FROM buildbase as dump1090
RUN  apt-get install libcap2-bin libusb-1.0-0-dev librtlsdr-dev dh-systemd libncurses5-dev libbladerf-dev libhackrf-dev liblimesuite-dev && \
    cd /tmp/build && \
    git clone https://github.com/flightaware/dump1090 && \
    cd /tmp/build/dump1090 && \
    git checkout tags/v5.0 -b v5.0 && \
    ./prepare-build.sh buster && \
    dpkg-buildpackage -b

############################################################################################################################################
# Build SoapySDR
#FROM buildbase as SoapySDR
#RUN  apt-get install swig python python-dev swig3.0 python3 python3-dev && \
#    cd /tmp/build && \
#    git clone https://github.com/pothosware/SoapySDR.git && \
#    cd /tmp/build/SoapySDR && \
#    dpkg-buildpackage -b

############################################################################################################################################
# Build SoapyRTLSDR
#FROM buildbase as SoapyRTLSDR
#COPY --from=SoapySDR /tmp/build/*.deb /tmp/build/
#RUN  apt install /tmp/build/libsoapysdr0.*_armhf.deb && \
#     apt install /tmp/build/libsoapysdr-dev_*-1_armhf.deb && \
#     apt-get install librtlsdr-dev && \
#     cd /tmp/build && \
#     git clone https://github.com/pothosware/SoapyRTLSDR.git && \
#     cd /tmp/build/SoapyRTLSDR && \
#     dpkg-buildpackage -b 

############################################################################################################################################
# Build rtlsdr-airband
FROM buildbase as RtlSdrAirband
#COPY --from=SoapySDR /tmp/build/*.deb /tmp/build/
ENV PLATFORM=rpiv2
RUN \
    apt-get install librtlsdr-dev libusb-1.0-0-dev libpulse-dev libconfig++-dev libogg-dev libvorbis-dev libshout3-dev libmp3lame-dev libraspberrypi-dev && \
#    apt install /tmp/build/libsoapysdr0.*_armhf.deb && \
#    apt install /tmp/build/libsoapysdr-dev_*-1_armhf.deb && \
    git clone https://github.com/szpajder/RTLSDR-Airband.git && \
    apt-get install libfftw3-dev && \
    cd RTLSDR-Airband && \
    git checkout unstable && \
    mkdir build && cd build && cmake .. && \
    make WITH_SOAPYSDR=0 PULSE=1 

############################################################################################################################################
# Build KALIBRATION TOOL
FROM buildbase as RtlSdrKalibration
ENV PLATFORM=rpiv2
RUN apt-get install libfftw3-dev librtlsdr-dev libusb-1.0-0-dev && \
    ########### Bug in pc file && \
    cd /usr/lib/arm-linux-gnueabihf/pkgconfig && \
    sed -i 's/^prefix=.*/prefix=\/usr/g' librtlsdr.pc && \
	sed -i 's/^exec_prefix=.*/exec_prefix=\$\{prefix\}/g' librtlsdr.pc && \
	sed -i 's/^libdir=.*/libdir=\$\{exec_prefix\}\/lib/g' librtlsdr.pc && \
	sed -i 's/^includedir=.*/includedir=\$\{prefix\}\/include/g' librtlsdr.pc && \
    ########### && \
    cd /tmp/build && \
    git clone https://github.com/steve-m/kalibrate-rtl && \
    cd /tmp/build/kalibrate-rtl && \
    ./bootstrap && CXXFLAGS='-W -Wall -O3' && ./configure && make && \
    cd src && ls -ial

############################################################################################################################################
# Build RtlAIS
FROM buildbase as RtlAIS
ENV PLATFORM=rpiv2
# git clone https://github.com/dgiardini/rtl-ais && \
RUN apt-get install libfftw3-dev librtlsdr-dev libusb-1.0-0-dev libpthread-workqueue-dev && \
    cd /tmp && \
    git clone https://github.com/mik3y/rtl-ais && \
    cd /tmp/rtl-ais && \
    sed -i 's/^LDFLAGS+=-lpthread.*/LDFLAGS+=-lpthread -lm -lrtlsdr -L \/usr\/lib\//' Makefile && \
    make && \
    ls rtl_ais 

############################################################################################################################################
# Create image that pits it all together
#FROM balenalib/armv7hf-debian
FROM balenalib/raspberrypi3:buster
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'APT::Get::Assume-Yes "true";\nAPT::Get::allow-remove-essential "true";' > /etc/apt/apt.conf.d/90forceyes && \
    echo 'APT::Install-Recommends "false";\nAPT::Install-Suggests "false";' > /etc/apt/apt.conf.d/90norecommends

COPY --from=dump1090 /tmp/build/*.deb /tmp/build/
#COPY --from=SoapySDR /tmp/build/*.deb /tmp/build/
#COPY --from=SoapyRTLSDR /tmp/build/*.deb /tmp/build/
COPY --from=RtlSdrAirband /tmp/RTLSDR-Airband/config/*  /usr/local/etc/
COPY --from=RtlSdrAirband /tmp/RTLSDR-Airband/build/src/rtl_airband  /usr/local/bin/
COPY --from=RtlSdrKalibration /tmp/build/kalibrate-rtl/src/kal  /usr/local/bin/
COPY --from=RtlAIS /tmp/rtl-ais/rtl_ais  /usr/local/bin/

RUN apt-get update && \
    apt-get full-upgrade && \
#    apt-get install systemd && \
    apt install /tmp/build/dump1090-fa_*_armhf.deb && \
#    apt install /tmp/build/libsoapysdr0.*_armhf.deb && \
#    apt install /tmp/build/soapysdr-tools_*_armhf.deb && \
    apt-get install librtlsdr0 libpulse0 libvorbisenc2 libmp3lame0 libshout-ocaml libconfig++9v5 libvorbisenc2 libmp3lame0 libshout-ocaml libconfig++9v5 libfftw3-3 && \
    apt-get install --reinstall libraspberrypi0 libraspberrypi-dev libraspberrypi-doc libraspberrypi-bin && \
    apt autoclean && apt clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# Install flightradar
#RUN apt-get install inetutils-ping wget && \
#    cd /tmp/build && \
#    wget https://repo-feed.flightradar24.com/install_fr24_rpi.sh && chmod 0700 install_fr24_rpi.sh && \
#     ./install_fr24_rpi.sh -a && \
#    rm -f install_fr24_rpi.sh

RUN echo -e "blacklist 8192cu" > /etc/modprobe.d/blacklist-8192cu.conf && \
    echo -e "blacklist rtl2832\nblacklist r820t\nblacklist rtl2830\nblacklist dvb_usb_rtl28xxu" > /etc/modprobe.d/blacklist-rtl8xxxu.conf

