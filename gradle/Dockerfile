FROM djphoenix/gitlab-runner:latest

RUN mkdir -p /usr/share/man/man1; \
    apt-get update; \
    apt-get install -y default-jdk-headless unzip ; \
    rm -rf /var/apt/cache ; \
    wget -O /tmp/gradle-bin.zip https://services.gradle.org/distributions/gradle-4.10.1-bin.zip ; \
    unzip -d /var/ /tmp/gradle-bin.zip ; \
    rm -rf /tmp/gradle-bin.zip ; \
    ln -s /var/gradle-4.10.1/bin/gradle /usr/bin/gradle

ENV JAVA_HOME /usr/lib/jvm/default-java

