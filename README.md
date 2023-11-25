![Logo Stream Studio](docs/assets/banner.png)
# Debian Bookworm Gstreamer Python Docker Image

run : 
```
sudo docker run -ti ghcr.io/stream-studio/video.gstreamer:1.22.4 gst-launch-1.0 --version
```

```
sudo docker run -ti ghcr.io/stream-studio/video.gstreamer:1.22.4 python3
```

```
import gi 
gi.require_version('Gst', '1.0')
Gst.init(None)
```