FROM arm32v7/alpine

RUN apk add --no-cache bash netcat-openbsd

ADD https://www.adsbhub.org/downloads/adsbhub.php adsbhub.sh
RUN chmod 0755 *.sh
CMD ["./adsbhub.sh"]
