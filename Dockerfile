FROM ubuntu:20.04
ARG GRAAL_URL=https://cdn-128.anonfiles.com/feW6BaDdx1/abfd14be-1643146806/graalvm-ee-java17-linux-amd64-22.0.0.tar.gz
ARG NATIVE_IMAGE_URL=https://cdn-101.anonfiles.com/TeU6BdDdx5/c657aba0-1643146660/native-image-installable-svm-svmee-java17-linux-amd64-22.0.0.jar

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales binutils procps bash libudev1 fonts-dejavu-core\
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

COPY slim-java* /usr/local/bin/

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    curl --retry 3 -Lfso /tmp/graalvm.tar.gz ${GRAAL_URL}; \
    curl --retry 3 -Lfso /tmp/native-image.jar ${NATIVE_IMAGE_URL}; \
    mkdir -p /opt/java/graalvm; \
    cd /opt/java/graalvm; \
    tar -xf /tmp/graalvm.tar.gz --strip-components=1; \
    export PATH="/opt/java/graalvm/bin:$PATH"; \
    /opt/java/graalvm/bin/gu -L install /tmp/native-image.jar; \
    /usr/local/bin/slim-java.sh /opt/java/graalvm; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /tmp/graalvm.tar.gz; \
    rm -rf /tmp/native-image.jar;
    
ENV JAVA_HOME=/opt/java/graalvm \
    PATH="/opt/java/graalvm/bin:$PATH"

CMD java -version
