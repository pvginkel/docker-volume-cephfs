FROM golang:1.10-alpine as builder
COPY . /go/src/github.com/n0r1skcom/docker-volume-cephfs
WORKDIR /go/src/github.com/n0r1skcom/docker-volume-cephfs
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
    gcc libc-dev \
    && go install --ldflags '-extldflags "-static"' \
    && apk del .build-deps
CMD ["/go/bin/docker-volume-cephfs"]

FROM alpine
RUN mkdir -p /run/docker/plugins /mnt/state /mnt/volumes
COPY --from=builder /go/bin/docker-volume-cephfs .
CMD ["docker-volume-cephfs"]
