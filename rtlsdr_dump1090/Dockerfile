FROM rvantwisk/rtlsdr_baseimage:202112201431

RUN apt autoclean && apt clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* && mkdir /ramdisk

RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output wait-for-it.sh && chmod +x wait-for-it.sh 

COPY wisdom.local ./
COPY start.sh ./
RUN chmod +x ./start.sh

EXPOSE 8080 30001 30002 30003 30004 30005 30104
CMD ./start.sh
