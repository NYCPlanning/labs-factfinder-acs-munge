FROM rocker/tidyverse:latest

RUN install2.r --error \
    --deps TRUE \
    readxl \
    tidyr \
    readr \
    plyr \
    reshape2 \
    uuid \
    stringr

COPY acs-munge.R /usr/local/src/scripts/
COPY decennial-munge.R /usr/local/src/scripts/
COPY bin /usr/local/src/scripts/bin

WORKDIR /usr/local/src/scripts

RUN mkdir -p input
RUN mkdir -p output
