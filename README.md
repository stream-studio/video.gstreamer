![Logo Stream Studio](docs/assets/banner.png)
# Debian Bookworm Gstreamer Python Docker Image

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