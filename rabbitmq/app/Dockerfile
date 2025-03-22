FROM debian:stable-slim AS dev

COPY --from=erlang:27-slim \
  /usr/local/bin/rebar3 \
  /usr/local/bin/

COPY --from=erlang:27-slim \
  /usr/local/lib/erlang/ \
  /usr/local/lib/erlang/

RUN set -xe \
  && for name in ct_run dialyzer epmd erl erlc escript run_erl to_erl typer; do \
      ln -s /usr/local/lib/erlang/bin/$name /usr/local/bin/$name; \
    done

COPY --from=elixir:1.18-slim \
  /usr/local/lib/elixir/ \
  /usr/local/lib/elixir/

COPY --from=elixir:1.18-slim \
  /usr/local/share/man/man1/elixir.1 \
  /usr/local/share/man/man1/elixirc.1 \
  /usr/local/share/man/man1/iex.1 \
  /usr/local/share/man/man1/mix.1 \
  /usr/local/share/man/man1/

RUN set -xe \
  && for name in elixir elixirc iex mix; do \
      ln -s /usr/local/lib/elixir/bin/$name /usr/local/bin/$name; \
    done

ENV DEBIAN_FRONTEND=noninteractive \
  LANG=C.UTF-8

ARG UID=1000
ARG GID=1000

RUN set -xe \
  && groupadd --gid "$GID" app \
  && useradd --create-home --home-dir /home/app --uid "$UID" --gid "$GID" app \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates inotify-tools

WORKDIR /home/app

USER app

RUN set -xe \
  && mix local.hex --force \
  && mix local.rebar --force

ENTRYPOINT ["sh", "-c", "[ $# -eq 0 ] && exec mix start || exec $@", "$@"]
