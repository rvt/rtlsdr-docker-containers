FROM arm32v7/alpine:3.11.12

RUN apk add --no-cache bash netcat-openbsd

ADD https://www.adsbhub.org/downloads/adsbhub.php adsbhub.sh
RUN chmod +x *.sh
CMD ["./adsbhub.sh"]
