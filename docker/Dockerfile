FROM eclipse-temurin:25.0.3_9-jdk-alpine-3.23@sha256:30d9f87d702c2c1c601ed0d31e0c88ea1ea474ee7676cda7b7a59e759181c4dd

USER root

RUN apk add --update --no-cache \
        bash \
        su-exec \
        tini \
    && apk --no-cache upgrade \
    && mkdir -p /lmdb_testbed \
    && addgroup --gid 1000 -S lmdb \
    && adduser --uid 1000 -D -S -h / -s /sbin/nologin -G lmdb lmdb \
    && set -ex \
    && chown -R 1000:1000 /lmdb_testbed


COPY --chown=lmdb:lmdb \
  ./build/lmdbjava-testbed-all.jar \
  /lmdb_testbed/

COPY --chown=lmdb:lmdb \
  ./entrypoint.sh \
  /lmdb_testbed/

VOLUME /lmdb_testbed
VOLUME /tmp

WORKDIR /lmdb_testbed

USER lmdb

# run entrypoint script inside tini for better unix process handling, 
# see https://github.com/krallin/tini/issues/8
ENTRYPOINT ["/sbin/tini", "--", "/lmdb_testbed/entrypoint.sh"]

# Run the basic test using the bundled LMDB binary
CMD [ "basic", "-d", "/tmp/lmdb_testbed" ]
