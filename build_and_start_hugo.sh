#!/bin/bash

# 从当前路径中读取hugo的版本号
HUGO_VERSION=`echo hugo* | cut -c 15-20`
# 容器挂载的博客的目录
ARG=$1
BLOG=${ARG:=/home/chengleqi/program/hugo/blog}


docker build --build-arg HUGO_VERSION=${HUGO_VERSION} -t chengleqi/docker-hugo:${HUGO_VERSION} .

if [ $? -ne 0 ];then
    echo -e "\033[31m 💥hugo image build failed... \033[0m"
else
    echo -e "\033[32m 🥳hugo image build successfully! \033[0m"
    echo -e "\033[32m 🐳start hugo container... \033[0m"
    docker run -it --rm -p 1313:1313 --name hugo_site -v $BLOG:/src chengleqi/docker-hugo:${HUGO_VERSION}
fi