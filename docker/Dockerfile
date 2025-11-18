FROM eclipse-temurin:21.0.8_9-jdk-alpine

USER root

RUN apk add --update --no-cache \
        bash \
        su-exec \
        tini \
    && apk --no-cache upgrade

        #lmdb \

RUN mkdir -p /lmdb_testbed

RUN addgroup --gid 1000 -S lmdb \
  && adduser --uid 1000 -D -S -h / -s /sbin/nologin -G lmdb lmdb;

RUN set -ex \
  && chown -R 1000:1000 /lmdb_testbed

COPY --chown=lmdb:lmdb ./build/lmdbjava-testbed-all.jar /lmdb_testbed/

WORKDIR /lmdb_testbed

USER lmdb

# run entrypoint script inside tini for better unix process handling, 
# see https://github.com/krallin/tini/issues/8
ENTRYPOINT ["/sbin/tini", "--"]

# This one requires the apk installs lmdb
#CMD ["java", "-Dlmdbjava.native.lib=/usr/lib/liblmdb.so.0.0.0", "--add-opens", "java.base/java.nio=ALL-UNNAMED", "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", "--add-opens", "java.base/java.lang=ALL-UNNAMED", "-jar", "/lmdb_testbed/lmdbjava-testbed-all.jar", "/tmp/lmdb"]

# This one requires that the alpine x86_64 lmdb lib is included in the lmdbjavatestbed classpath.
CMD ["java", "-Dlmdbjava.embedded.lib=lmdbjavatestbed/x86_64-linux-musl.so", "--add-opens", "java.base/java.nio=ALL-UNNAMED", "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED", "--add-opens", "java.base/java.lang=ALL-UNNAMED", "-jar", "/lmdb_testbed/lmdbjava-testbed-all.jar", "/tmp/lmdb"]
