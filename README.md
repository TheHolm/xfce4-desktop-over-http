# Docker XFCE desktop over HTTP

A lightweight (519 MB) Linux workstation based on [Debian](https://debian.org/). Provides a **graphical desktop** via HTTP.

**Based on two projects**
 * [fcwu/docker-ubuntu-vnc-desktop](https://github.com/fcwu/docker-ubuntu-vnc-desktop)
 * [rwildcat/docker_ubuntu-vnc](https://github.com/rwildcat/docker_ubuntu-vnc)

but it is not a fork of any of them.

**Last update**: 6 Oct 2022.  
**Base image**: [Debian 11.5 bullseye](https://hub.docker.com/_/debian/)


## Main packages

* **xfce4**   : Graphic desktop environment
* **x11vnc**  : X vnc server
* **novnc**    : HTTP-to-VNC gateway
* **firefox-esr** : Web browser
* **chromium**    : Web browser

## Usage (synopsis)

1. (Optional) Download (*pull*) the image from its [docker hub repository](https://hub.docker.com/r/theholm/xfce4-desktop-over-http).

	If this step is not done first and the image does not previously exists in your local computer, the image will be downloaded later by the `docker run` command:

   ```sh
   $ docker pull theholm/xfce4-desktop-over-http
   ```

2. Run the container.

	For example:

	* To run session (port 6080):

		```sh
	   $ docker run --rm -p 127.0.0.01:6080:6080 theholm/xfce4-desktop-over-http
	   ```

3. Connect to the virtual computer using any modern web browser by browsing to [127.0.0.1:6080](http://127.0.0.1:6080)

---

## Usage (full syntax)

To run the container, you can just issue the `$ docker run <image-name>` command. The image will be first *pulled* if it not previously done:

**Full syntax:**

```sh
$ docker run [-it] [--rm] [--detach] [-h HOSTNAME] -p HTTPPORT:6080 -p LSSHPORT:22 [-e XRES=1280x800x24] [-e TZ={TZArea/TZCity}] [-v LDIR:DIR] theholm/xfce4-desktop-over-http
```

where:

* `HTTPPORT`: Localhost port where desktop will be available.

* `XRES`: Screen resolution and color depth. Default: `1200x800x24`

* `TZ`: Local Timezone Area/City, e.g. `Etc/UTC`, `America/Mexico_City`, etc.

* `LDIR:DIR`: Local directory to mount on container. `LDIR` is the local directory to export; `DIR` is the target dir on the container.  Both sholud be specified as absolute paths. For example: `-v $HOME/worskpace:/home/user/workspace`.
