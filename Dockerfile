FROM debian:11.5

# default screen size
ENV XRES=1280x800x24

# default tzdata
ENV TZ=Etc/UTC

# apt install novnc net-tools

# update and install software
RUN export DEBIAN_FRONTEND=noninteractive  \
	&& apt-get update -q \
	&& apt-get upgrade -qy \
	&& apt-get install -qy  --no-install-recommends \
	apt-utils sudo supervisor vim openssh-server \
	xserver-xorg xvfb x11vnc dbus-x11 \
	xfce4 xfce4-terminal xfce4-xkb-plugin  \
	novnc net-tools \
	firefox-esr chromium \
	\
	# fix "LC_ALL: cannot change locale (en_US.UTF-8)""
	locales \
	&& echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
	&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "LANG=en_US.UTF-8" > /etc/locale.conf \
	&& locale-gen en_US.UTF-8 \
	\
	# keep it slim
	# 	&& apt-get remove -qy \
	\
	# cleanup and fix
	&& apt-get autoremove -y \
	&& apt-get --fix-broken install \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# required preexisting dirs
# RUN mkdir /run/sshd

# users and groups
RUN	useradd -m user -s /bin/bash \
    && echo "user:6HcDX0vBm7ETdujXUZAH7R8hvdbgJO" | /usr/sbin/chpasswd

# add my sys config files
ADD etc /etc

# making it auto start
RUN /bin/ln -s /usr/share/novnc/vnc_auto.html /usr/share/novnc/index.html

# make chromium run in docker.  Sand-boxing will not work without --privileged
RUN /bin/sed -Ei 's/(Exec=.+chromium) (\%U)/\1 --no-sandbox \2/' /usr/share/applications/chromium.desktop

# user config files

# terminal
ADD config/xfce4/terminal/terminalrc /home/user/.config/xfce4/terminal/terminalrc
# wallpaper
ADD config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /home/user/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
# icon theme
ADD config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml /home/user/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

# TZ, aliases
RUN cd /home/user \
	&& echo 'export TZ=/usr/share/zoneinfo/$TZ' >> .bashrc \
	&& sed -i 's/#alias/alias/' .bashrc

# set owner
RUN chown -R user:user /home/user/.*

# ports
EXPOSE 6080

# # default command
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
