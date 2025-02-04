FROM alpine:3.13 AS builder
ARG NSJAIL_VERSION

RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; apk --no-cache add git build-base pkgconfig flex bison linux-headers bsd-compat-headers protobuf-dev libnl3-dev

RUN git clone https://github.com/google/nsjail && \
    cd nsjail/ && \
    git checkout "$NSJAIL_VERSION" && \
    make -j$(nproc)


FROM alpine:3.13

RUN apk --no-cache add libstdc++ libnl3 protobuf iproute2 iptables

COPY --from=builder /nsjail/nsjail /usr/sbin/nsjail
COPY firewall.sh /usr/local/sbin/firewall.sh

LABEL org.opencontainers.image.source https://github.com/edocme/nsjail-alpine
