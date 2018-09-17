FROM debian:9-slim AS deps

RUN apt-get update ; \
    apt-get install -y \
       git patch curl wget tar unzip \
       autoconf automake make \
       gcc g++ gperf gettext \
       bison flex texinfo bzip2 \
       help2man gawk libtool-bin \
       ncurses-dev python-dev ; \
    rm -rf /var/apt/cache

ADD xtensa-toolchain-installer /var/xtensa-toolchain-installer


FROM deps AS lx106

RUN cd /var/xtensa-toolchain-installer ; make TARGET=lx106

FROM deps AS esp32

RUN cd /var/xtensa-toolchain-installer ; make TARGET=esp32


FROM djphoenix/gitlab-runner:latest

COPY --from=lx106 /var/xtensa-toolchain-installer/xtensa-*-elf.tbz2 /var/
COPY --from=esp32 /var/xtensa-toolchain-installer/xtensa-*-elf.tbz2 /var/

RUN apt-get update ; \
    apt-get install -y tar python python-pip zip gawk xxd ; \
    rm -rf /var/apt/cache ; \
    cd /usr ; \
    tar xvf /var/xtensa-lx106-elf.tbz2 ; \
    tar xvf /var/xtensa-esp32-elf.tbz2 ; \
    pip install esptool==2.0.1 ; \
    rm /var/xtensa-*-elf.tbz2

