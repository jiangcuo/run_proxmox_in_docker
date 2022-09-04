FROM debian:11

#set mirror
RUN rm /etc/apt/sources.list && \
echo "deb http://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://mirrors.ustc.edu.cn/debian-security bullseye-security main contrib" >> /etc/apt/sources.list

#install base pkg
RUN apt-get update && \
apt-get install wget sudo systemctl nano vim   curl gnupg  ca-certificates -y

#proxmox-ve need pve-kernel,So we need repack proxmox-ve,delete pve-kernel in it's depends.
#use apt-mirror download pkg then replaced proxmox-ve.
RUN echo "deb  http://10.13.14.10/pve/ /" >>/etc/apt/sources.list.d/pve.list
COPY gpg.key /
RUN cat /gpg.key|apt-key add -

#intall proxmox-ve without recommends. ifupdown2 will install failed but ok
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractiv apt-get -y --no-install-recommends  install proxmox-ve openssh-server  || echo ok

#set passwd for root
RUN echo "root:root"|chpasswd

#clean
RUN rm -rf /var/lib/apt/lists/*

#use setup.sh to start proxmox service
COPY setup.sh /
RUN chmod a+x /setup.sh
STOPSIGNAL SIGINT
CMD [ "/lib/systemd/systemd", "log-level=info", "unit=sysinit.target","&&","bash","/setup.sh" ]
