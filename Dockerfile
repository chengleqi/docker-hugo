FROM alpine
LABEL description="Docker container for building static sites with the Hugo static site generator."
LABEL maintainer="chengleqi <chengleqi5g@hotmail.com>"

# config
ENV HUGO_VERSION=0.86.1
#ENV HUGO_TYPE=
ENV HUGO_TYPE=_extended

ENV HUGO_ID=hugo${HUGO_TYPE}_${HUGO_VERSION}
COPY ./run.sh /run.sh
COPY hugo_extended_0.86.1_Linux-64bit.tar.gz /hugo_extended_0.86.1_Linux-64bit.tar.gz
RUN tar -xzf /hugo_extended_0.86.1_Linux-64bit.tar.gz -C /tmp \
    && mkdir -p /usr/local/sbin \
    && mv /tmp/hugo /usr/local/sbin/hugo \
    && rm -rf /tmp/${HUGO_ID}_linux_amd64 \
    && rm -rf /tmp/LICENSE \
    && rm -rf /tmp/README.md \
    && rm -rf /hugo_extended_0.86.1_Linux-64bit.tar.gz
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --update git asciidoctor libc6-compat libstdc++ \
    && apk upgrade \
    && apk add --no-cache ca-certificates \
    && chmod 0777 /run.sh

VOLUME /src

WORKDIR /src
CMD ["/run.sh"]

EXPOSE 1313