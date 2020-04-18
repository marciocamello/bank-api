FROM elixir:1.10-alpine AS builder

WORKDIR     /opt/app

RUN         apk add \
              build-base && \
              mix local.rebar --force && \
              mix local.hex --force

ADD         mix.exs mix.lock ./
RUN         mix do deps.get --only prod, deps.compile

COPY        . ./

RUN         MIX_ENV=prod mix release --path ../built


FROM alpine:3.9

RUN          apk add \
              bash 

WORKDIR      /opt/app/bin

COPY         --from=builder /opt/built ../

ENV          PATH="$PATH:$PWD"

ENTRYPOINT   ["server", "start"]