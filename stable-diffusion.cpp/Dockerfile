ARG CUDA_VERSION=12.9.2
ARG UBUNTU_VERSION=24.04

FROM nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION} AS build

ARG APP_UID=1000
ARG APP_GID=1000

RUN set -xeu \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential git ccache cmake ca-certificates curl gnupg ninja-build pkg-config libwebp-dev \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key -o /tmp/nodesource-repo.gpg.key \
  && gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg /tmp/nodesource-repo.gpg.key \
  && rm /tmp/nodesource-repo.gpg.key \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && corepack enable pnpm \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV CUDACXX=/usr/local/cuda/bin/nvcc
ENV GGML_CUDA_ENABLE_DYNAMIC_CPU_BACKENDS=ON

USER ubuntu
