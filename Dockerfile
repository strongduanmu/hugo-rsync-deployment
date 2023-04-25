FROM debian:stable-20230411-slim

LABEL "name"="Hugo rsync deployment"
LABEL "maintainer"="Ron van der Heijden <r.heijden@live.nl>"
LABEL "version"="0.1.6"

LABEL "com.github.actions.name"="Hugo rsync deployment"
LABEL "com.github.actions.description"="An action that generates and deploys a static website using Hugo and rsync."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/ronvanderheijden/hugo-rsync-deployment"
LABEL "homepage"="https://ronvanderheijden.nl/"

RUN apt-get update
RUN apt-get install \
        gettext \
        hugo \
        openssh-client \
        rsync

ADD entrypoint.sh /
RUN chmod 777 /tmp
RUN chmod +x /entrypoint.sh

RUN addgroup -S appuser -g 1000 && adduser -u 1000 -S appuser -G appuser
USER appuser

ENTRYPOINT ["/entrypoint.sh"]
