FROM ubuntu:latest

ENV VERSION="1.2.0"

RUN apt-get update -y && apt upgrade -y
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && apt-cache search python3.1
RUN apt install vim zip unzip -y
COPY zip_job.py /tmp/zip_job.py
CMD lsb_release -a ; uname -a ; ls -l /tmp
#ENTRYPOINT ["tail", "-f", "/dev/null"]

RUN apt-get update && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*

USER jenkins

