# Use Alpine Linux as our base image so that we minimize the overall size our final container, and minimize the surface area of packages that could be out of date.
FROM alpine
LABEL description="Docker container for building static sites with the Hugo static site generator."
LABEL maintainer="chengleqi <chengleqi5g@hotmail.com>"

# config HUGO_VERSION需要修改
ARG HUGO_VERSION
ENV HUGO_VERSION=${HUGO_VERSION}
ENV HUGO_TYPE=_extended
ENV HUGO_ID=hugo${HUGO_TYPE}_${HUGO_VERSION}

COPY ${HUGO_ID}_Linux-64bit.tar.gz /${HUGO_ID}_Linux-64bit.tar.gz
RUN tar -xzf /${HUGO_ID}_Linux-64bit.tar.gz -C /tmp \
    && mkdir -p /usr/local/sbin \
    && mv /tmp/hugo /usr/local/sbin/hugo \
    && rm -rf /tmp/${HUGO_ID}_linux_amd64 \
    && rm -rf /tmp/LICENSE \
    && rm -rf /tmp/README.md \
    && rm -rf /${HUGO_ID}_Linux-64bit.tar.gz

# 将apk更改为阿里云源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# golang binary在alpine中运行的必要条件
RUN apk add --update git asciidoctor libc6-compat libstdc++ \
    && apk upgrade \
    && apk add --no-cache ca-certificates \
    && chmod 0777 /run.sh

# 挂载卷
VOLUME /src

WORKDIR /src
CMD ["hugo", "server", "--bind=0.0.0.0", "--disableFastRender"]

EXPOSE 1313