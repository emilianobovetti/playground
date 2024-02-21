FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive \
  LANG=C.UTF-8

COPY --from=erlang:26-slim \
  /usr/local/bin/rebar3 \
  /usr/local/bin/

COPY --from=erlang:26-slim \
  /usr/local/lib/erlang/ \
  /usr/local/lib/erlang/

ARG UID=1000
ARG GID=1000

RUN set -xe \
  && for name in ct_run dialyzer epmd erl erlc escript run_erl to_erl typer; do \
      ln -s /usr/local/lib/erlang/bin/$name /usr/local/bin/$name; \
    done \
  && apt-get update \
  && apt-get install -y --no-install-recommends make libssl3 \
  && groupadd --gid "$GID" app \
  && useradd --create-home --home-dir /home/app --uid "$UID" --gid "$GID" app

WORKDIR /home/app

USER app
