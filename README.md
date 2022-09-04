# run_proxmox_in_docker
Run pve services in docker container

## 安装说明
官方proxmox-ve需要pve-kernel。但是在容器不好安装pve-kernel，所以需要重新编译proxmox-ve或者重新打包
重新打包很方便，你可以使用下面命令
```
wget https://mirrors.ustc.edu.cn/proxmox/debian/dists/bullseye/pve-no-subscription/binary-amd64/proxmox-ve_7.2-1_all.deb
mkdir /tmp/pve
dpkg -X proxmox-ve_7.2-1_all.deb /tmp/pve/ 
dpkg -e proxmox-ve_7.2-1_all.deb /tmp/pve/DEBIAN
#edit /tmp/pve/DEBIAN
sed -i "s/pve-kernel-helper,//g" /tmp/pve/DEBIAN/control
sed -i "s/pve-kernel-5.15,//g" /tmp/pve/DEBIAN/control
dpkg-deb -Zxz  -b /tmp/pve/ ../
```
这样，你可以在上级目录，看到重新打包后的文件。
