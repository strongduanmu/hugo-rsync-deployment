FROM debian:stable-slim

LABEL "name"="Hugo rsync deployment"
LABEL "maintainer"="Ron van der Heijden <r.heijden@live.nl>"
LABEL "version"="0.1.6"

LABEL "com.github.actions.name"="Hugo rsync deployment"
LABEL "com.github.actions.description"="An action that generates and deploys a static website using Hugo and rsync."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/ronvanderheijden/hugo-rsync-deployment"
LABEL "homepage"="https://ronvanderheijden.nl/"

## to make image building faster in self-hosted
# RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ stable main" > /etc/apt/sources.list &&\
#     echo "deb http://deb.debian.org/debian-security stable-security main" >> /etc/apt/sources.list &&\
#     echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ stable-updates main" >> /etc/apt/sources.list

ARG HUGO_VERSION=0.111.3

RUN apt-get update \
 && apt-get install -y --no-install-recommends wget ca-certificates tar \
 && wget -q https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
 && tar -xzf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz -C /usr/local/bin hugo \
 && rm hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
 && chmod +x /usr/local/bin/hugo \
 && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN chmod 777 /tmp

#RUN addgroup --gid 1000 appuser && adduser --uid 1000 --gid 1000 appuser
#USER appuser

ENTRYPOINT ["/entrypoint.sh"]
