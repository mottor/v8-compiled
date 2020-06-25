FROM php:7.3-fpm-stretch

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install required dependencies
RUN apt-get install -y build-essential curl git python libglib2.0-dev

# Install depot_tools first (needed for source checkout)
RUN cd /tmp \
    && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git \
    && export PATH=`pwd`/depot_tools:"$PATH" \

    # Download v8
    && fetch v8 \
    && cd v8 \

    # (optional) If you'd like to build a certain version:
    && git checkout 6.4.388.18 \
    && gclient sync \

    # Setup GN
    && tools/dev/v8gen.py -vv x64.release -- is_component_build=true \

    # Build
    && ninja -C out.gn/x64.release/ \

    # Install to /usr/local/
    && mkdir -p /usr/local/{lib,include} \
    && cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin \
        out.gn/x64.release/icudtl.dat /usr/local/lib/ \
    && cp -R include/* /usr/local/include/

# Only for Debian Stretch
RUN apt-get install -y patchelf
RUN for A in /usr/local/lib/*.so; do patchelf --set-rpath '$ORIGIN' $A; done