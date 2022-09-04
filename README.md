# run_proxmox_in_docker
Run pve services in docker container

## How to Use

### RUN unprivileged
```
docker run -idt --network host --device=/dev/kvm \
--cap-add SYS_ADMIN --device /dev/fuse \
--name pve \
--add-host pve:10.13.14.101 \
--hostname pve \
registry.cn-chengdu.aliyuncs.com/bingsin/pve:test-7.2-7
```

### RUN privileged
```
docker run -idt --network host \
--privileged
--name pve \
--add-host pve:10.13.14.101 \
--hostname pve \
registry.cn-chengdu.aliyuncs.com/bingsin/pve:test-7.2-7
```
