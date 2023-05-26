FROM ubuntu:22.04


# Build configuration arguments

ARG http_proxy
ARG https_proxy
ENV http_proxy ${http_proxy}
ENV https_proxy ${https_proxy}

ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y locales && apt-get clean autoclean && apt-get autoremove -y
RUN apt-get update && apt-get -y --no-install-recommends install \
libpci-dev libnl-3-dev libnl-genl-3-dev gettext \
libgettextpo-dev autopoint gettext libncurses5-dev libncursesw5-dev libtool-bin \
dh-autoreconf autoconf-archive pkg-config git build-essential
WORKDIR /
RUN git config --global http.sslVerify false
RUN git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/ \
&& cd libtraceevent && make && make install && cd ..;

RUN git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/ \
&& cd libtracefs && make && make install && cd ..;
RUN git clone https://github.com/fenrus75/powertop.git \
&& cd powertop && ./autogen.sh && ./configure LDFLAGS=-static && make
