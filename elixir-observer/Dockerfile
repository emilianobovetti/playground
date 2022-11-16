FROM elixir

ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} alchymist && \
  useradd -u ${UID} -g alchymist alchymist && \
  mkdir -p /home/alchymist/src && \
  chown -R alchymist:alchymist /home/alchymist

USER alchymist

WORKDIR /home/alchymist/src
