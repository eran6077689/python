FROM ubuntu:latest

ENV VERSION="1.2.0"

RUN apt-get update -y && apt upgrade -y
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && apt-cache search python3.1
RUN apt install vim zip unzip default-jre -y
RUN apt install curl git git-lfs  -y
# RUN apt install musl-locales -y
RUN apt install openssh-client openssl procps -y
COPY zip_job.py /tmp/zip_job.py
CMD lsb_release -a ; uname -a ; ls -l /tmp
#ENTRYPOINT ["tail", "-f", "/dev/null"]

# from here I tried to add the Jenkins Agent packages according to what i read ..
ARG JAVA_VERSION="11.0.15_10"

ARG VERSION=4.13
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN addgroup --gid 1000 jenkins
RUN adduser --home /home/jenkins --uid 1000 --gid 1000 jenkins
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="${VERSION}"

ARG AGENT_WORKDIR=/home/jenkins/agent

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar \
  && rm -rf /tmp/*.apk /tmp/gcc /tmp/gcc-libs.tar* /tmp/libz /tmp/libz.tar.xz /var/cache/apk/*

# To do: remove CURL - Vulnerability

USER jenkins
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/jenkins/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/jenkins

LABEL \
    org.opencontainers.image.vendor="Jenkins project" \
    org.opencontainers.image.title="Official Jenkins Agent Base Docker image" \
    org.opencontainers.image.description="This is a base image, which provides the Jenkins agent executable (agent.jar)" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.url="https://www.jenkins.io/" \
    org.opencontainers.image.source="https://github.com/jenkinsci/docker-agent" \
    org.opencontainers.image.licenses="MIT"

RUN echo 38ae4e7b890058abd7555f46b2954da4f63c4ca7feadd7b0a24af672efa44980 > secret-file
RUN cp /usr/share/jenkins/agent.jar /home/jenkins/agent.jar
#CMD ["java", "-jar", "agent.jar", "-jnlpUrl", "http://192.168.65.7:40000/computer/local%2Deran/jenkins-agent.jnlp", "-secret", "@secret-file", "-workDir", "/home/jenkins"]

