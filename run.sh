#!/bin/sh
CONTAINER="boot_demo" \
# 镜像名称（以日期时间为镜像标签，防止重复）
IMAGE=$CONTAINER":"$(date -d "today" +"%Y%m%d_%H%M%S") \
#stop 容器,过滤出CONTAINER
var=$(docker ps | grep $CONTAINER) \
#得到 CONTAINERID
CONTAINERID=${var:0:12} \
# 如果 CONTAINERID 字符长度12 就stop
if test ${#CONTAINERID} -eq 12
then
	docker stop $CONTAINERID
fi
# 删除滚动更新残留的容器
docker rm `docker ps -a | grep -w $CONTAINER | awk '{print $1}'` || true
# 强制删除滚动更新残留的镜像
docker rmi --force `docker images | grep -w $CONTAINER | awk '{print $3}'` || true

# 创建新镜像
docker build -t $IMAGE . && \
docker run -d -p 9999:8090 $IMAGE

# 构建后需要Jenkins 执行的脚本