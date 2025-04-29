![Logo Stream Studio](docs/assets/banner.png)
# Debian Bookworm Gstreamer Python Docker Image

build:

```
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/stream-studio/video.gstreamer1.24.10-builder --target builder --push .
```

run : 
```
sudo docker run -ti ghcr.io/stream-studio/video.gstreamer:1.24 gst-launch-1.0 --version
```

```
sudo docker run -ti ghcr.io/stream-studio/video.gstreamer:1.24 python3
```

```
import gi 
gi.require_version('Gst', '1.0')
Gst.init(None)
```

AMD64
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v8 -t ghcr.io/stream-studio/video.gstreamer --push .