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

# 先更新 key，避免 NO_PUBKEY 错误
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        debian-archive-keyring \
 && rm -rf /var/lib/apt/lists/*

# 安装必须的软件
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        gettext \
        hugo \
        openssh-client \
        rsync \
 && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN chmod 777 /tmp

ENTRYPOINT ["/entrypoint.sh"]
