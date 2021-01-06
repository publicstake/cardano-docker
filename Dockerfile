FROM ubuntu:20.04

ENV CARDANO_VERSION 1.24.2
ENV TZ=Etc/UTC
ENV PATH /root/.local/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir -p /root/.local/bin
