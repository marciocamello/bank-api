# BUILD
# IMAGE
FROM elixir:1.10-alpine as build

# MAINTAINER
LABEL Maintainer="Marcio Camello <mac3designer@gmail.com>" \
      Description="BankAPI Elixir image with Phoenix Framework"

# ADDING DEPENDENCIES
RUN apk add --no-cache build-base npm git python

# BUILD DIR
WORKDIR /app

# INSTALL HEX + REBAR
RUN mix local.hex --if-missing --force && \
    mix local.rebar --force

# MIX ENVIRONMENT
ENV MIX_ENV=prod

# INSTALL MIX DEPENDENCIES
RUN pwd
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get

# COPY PRIV AND LIB
COPY priv priv
COPY lib lib

# COMPILE RELEASE
RUN mix do clean, compile --force
RUN mix distillery.release

# CLEAR CACHE
RUN rm -rf /var/cache/* \
    && rm -rf /tmp/*

# DEPLOY RELEASE IMAGE
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app
RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/bank_api ./

ENV HOME=/app

CMD ["bin/bank_api", "start"]