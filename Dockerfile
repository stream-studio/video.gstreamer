
FROM debian:bookworm-slim as builder


ENV GSTREAMER_VERSION=1.24.10
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf `# libnice` \
    automake `# libnice` \
    bison \
    build-essential \
    ca-certificates \
    flex \
    gettext \
    git \
    gnutls-dev `# libnice` \
    gtk-doc-tools `# libnice` \
    libffi-dev \
    libglib2.0 \
    libopus-dev \
    libpcre3-dev \
    libsrtp2-dev \
    libssl-dev `# needed for DTLS requirement`\
    libtool `# libnice` \
    libvpx-dev \
    libx264-dev \
    libx265-dev \
    mount \
    perl \
    python3 \
    python3-pip\
    python3-setuptools\
    wget \
    libavcodec-dev \
    zlib1g \
    python3-gi \
    python3-dev \
    python-gi-dev \
    python3-wheel \ 
    libcairo2-dev \
    ninja-build \
    libsoup-3.0-dev \
    gobject-introspection \
    libgirepository1.0-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --break-system-packages PyGObject \
    && pip3 install --break-system-packages meson \
    && wget https://gstreamer.freedesktop.org/src/orc/orc-0.4.40.tar.xz \
    && tar xvfJ orc-0.4.40.tar.xz > /dev/null \
    && cd orc-0.4.40 \
    && meson build --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \
    && wget https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${GSTREAMER_VERSION}.tar.xz \
    && tar xvfJ gstreamer-${GSTREAMER_VERSION}.tar.xz > /dev/null \
    && cd gstreamer-${GSTREAMER_VERSION} \
    && meson build --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \
# gst-plugins-base
    && wget https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GSTREAMER_VERSION}.tar.xz \
    && tar xvfJ gst-plugins-base-${GSTREAMER_VERSION}.tar.xz > /dev/null \
    && cd gst-plugins-base-${GSTREAMER_VERSION} \
    && meson build --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \
# libnice
    && git clone https://github.com/libnice/libnice.git \
    && cd libnice \
    && meson build --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \
    && rm -rf libnice \
# gst-plugins-good
    && wget https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GSTREAMER_VERSION}.tar.xz \
    && tar xvfJ gst-plugins-good-${GSTREAMER_VERSION}.tar.xz > /dev/null \
    && cd gst-plugins-good-${GSTREAMER_VERSION} \
    && meson build --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \
# gst-plugins-bad
    && wget https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GSTREAMER_VERSION}.tar.xz \
    && tar xvfJ gst-plugins-bad-${GSTREAMER_VERSION}.tar.xz > /dev/null \
    && cd gst-plugins-bad-${GSTREAMER_VERSION} \
    && meson build -Dgpl=enabled --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \
# gst-plugins-ugly
    && wget https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${GSTREAMER_VERSION}.tar.xz \
    && tar xvfJ gst-plugins-ugly-${GSTREAMER_VERSION}.tar.xz > /dev/null \
    && cd gst-plugins-ugly-${GSTREAMER_VERSION} \
    && meson build -Dgpl=enabled --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \
# gst-rtsp-server
    && wget https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-${GSTREAMER_VERSION}.tar.xz \
    && tar xvfJ gst-rtsp-server-${GSTREAMER_VERSION}.tar.xz > /dev/null \
    && cd gst-rtsp-server-${GSTREAMER_VERSION} \
    && meson build --prefix=/usr/ \
    && ninja -C build  \
    && ninja -C build install \
    && cd / \
    && wget https://gstreamer.freedesktop.org/src/gst-python/gst-python-${GSTREAMER_VERSION}.tar.xz \
    && tar xvfJ gst-python-${GSTREAMER_VERSION}.tar.xz > /dev/null \
    && cd gst-python-${GSTREAMER_VERSION} \
    && meson build --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \
    && git clone https://github.com/stream-studio/gst-plugins-studio \
    && cd gst-plugins-studio \
    && meson build --prefix=/usr/ \
    && ninja -C build \
    && ninja -C build install \
    && cd / \    
    && rm -rf gst* \
    && rm -rf /var/lib/apt/lists/*


FROM debian:bookworm-slim as runtime

ENV GSTREAMER_VERSION=1.24.10

COPY --from=builder /usr/bin/gst* /usr/bin/
COPY --from=builder /usr/lib/*-linux-gnu/liborc-0.4.so /usr/lib/
COPY --from=builder /usr/lib/*-linux-gnu/libgst* /usr/lib/
COPY --from=builder /usr/lib/*-linux-gnu/libnice.so /usr/lib/
COPY --from=builder /usr/lib/*-linux-gnu/gstreamer-1.0 /usr/lib/gstreamer-1.0
COPY --from=builder /usr/lib/*-linux-gnu/girepository-1.0 /usr/lib/girepository-1.0


RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libffi8 \
    libvpx7 \
    libopus0 \
    libx264-164 \
    libx265-199 \
    libpng16-16 \
    libx11-6 \
    libcairo2 \
    python3 \
    python3-pip \
    python3-gi \
    libpython3.11 \
    libsrtp2-1 \
    libcairo-gobject2 \
    libgirepository-1.0-1 \
    libsoup-3.0 \
    && rm -rf /var/lib/apt/lists/*

# Définir le point d'entrée
CMD ["bash"]