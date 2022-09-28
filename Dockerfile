FROM debian:11

#set mirror
RUN rm /etc/apt/sources.list && \
echo "deb http://mirrors.ustc.edu.cn/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://mirrors.ustc.edu.cn/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://mirrors.ustc.edu.cn/debian/ bullseye-backports main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://mirrors.ustc.edu.cn/debian-security bullseye-security main contrib" >> /etc/apt/sources.list

#install base pkg
RUN apt-get update && \
apt-get install wget  systemctl nano vim  curl gnupg  ca-certificates -y

#add proxmox repo
RUN echo "deb http://mirrors.ustc.edu.cn/proxmox/debian/ bullseye pve-no-subscription" >>/etc/apt/sources.list && \
curl https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg|apt-key add -


#repacked proxmox-ve
RUN wget https://mirrors.ustc.edu.cn/proxmox/debian/dists/bullseye/pve-no-subscription/binary-amd64/proxmox-ve_7.2-1_all.deb && \
mkdir /tmp/pve && \
dpkg -X proxmox-ve_7.2-1_all.deb /tmp/pve/ && \
dpkg -e proxmox-ve_7.2-1_all.deb /tmp/pve/DEBIAN && \
sed -i "s/pve-kernel-helper,//g" /tmp/pve/DEBIAN/control && \
sed -i "s/pve-kernel-5.15,//g" /tmp/pve/DEBIAN/control && \
dpkg-deb -Zxz  -b /tmp/pve/ /tmp/


#repacked pve-manager
RUN wget https://mirrors.ustc.edu.cn/proxmox/debian/dists/bullseye/pve-no-subscription/binary-amd64/pve-manager_7.2-7_amd64.deb && \
mkdir /tmp/pve-manager && \
dpkg -X pve-manager_7.2-7_amd64.deb  /tmp/pve-manager/ && \
dpkg -e pve-manager_7.2-7_amd64.deb /tmp/pve-manager/DEBIAN && \
sed -i "s/ifupdown2 (>= 2.0.1-1+pve8) | ifenslave (>= 2.6),//g" /tmp/pve-manager/DEBIAN/control && \
dpkg-deb -Zxz  -b /tmp/pve-manager/ /tmp

#intall proxmox-ve without recommends. ifupdown2 will install failed but ok
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractiv apt-get -y --no-install-recommends  install  proxmox-ve || echo ok

##install again
RUN dpkg -i /tmp/*.deb || echo ok

#set passwd for root
RUN echo "root:root"|chpasswd

#clean
RUN rm -rf /var/lib/apt/lists/*  /*.deb

#use setup.sh to start proxmox service
STOPSIGNAL SIGINT
CMD [ "/lib/systemd/systemd", "log-level=info", "unit=sysinit.target"]
