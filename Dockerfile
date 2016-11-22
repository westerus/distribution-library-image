# Build a minimal distribution container

FROM alpine:3.4

ARG USER_ID=registry
ARG USER_UID=995
ARG GROUP_ID=$USER_ID
ARG GROUP_UID=994

RUN set -ex \
    && addgroup -S -g $GROUP_UID $GROUP_ID \
    && adduser -S -D -H -G $GROUP_ID -u $USER_UID $USER_ID \
    && apk add --no-cache ca-certificates apache2-utils

COPY ./registry/registry /bin/registry
COPY ./registry/config-example.yml /etc/docker/registry/config.yml

VOLUME ["/var/lib/registry"]
EXPOSE 5000

COPY docker-entrypoint.sh /entrypoint.sh
USER $USER_ID
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/etc/docker/registry/config.yml"]
