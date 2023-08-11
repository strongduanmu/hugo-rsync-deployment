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
RUN apt-get install -y \
        gettext \
        hugo \
        openssh-client \
        rsync

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN chmod 777 /tmp

RUN addgroup --gid 1000 appuser && adduser --uid 1000 --gid 1000 appuser
USER appuser
RUN chown :appuser /tmp

ENTRYPOINT ["/entrypoint.sh"]
