FROM rvantwisk/rtlsdr_baseimage:latest

COPY start.sh ./

RUN \
  curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output wait-for-it.sh && chmod +x wait-for-it.sh && \
  chmod +x ./start.sh 


CMD ./wait-for-it.sh pulseaudio_server:4713 && ./start.sh
