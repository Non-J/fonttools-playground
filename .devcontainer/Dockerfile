FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

RUN apt update && export DEBIAN_FRONTEND=noninteractive \
    && apt -y install --no-install-recommends python3-pip

RUN pip install fonttools[ufo,lxml,woff,unicode] gftools
