# BUILD
# IMAGE
FROM elixir:1.10-alpine as builder

# ALPINE VERSION
ARG ALPINE_VERSION=3.9

# ARGS
ARG APP_NAME
ARG APP_VSN
ARG DATABASE_URL
ARG MIX_ENV=prod

# ENVS
ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    DATABASE_URL=${DATABASE_URL} \
    MIX_ENV=${MIX_ENV}

# MAINTAINER
LABEL Maintainer="Marcio Camello <mac3designer@gmail.com>" \
      Description="BankAPI Elixir image with Phoenix Framework"

# ADDING DEPENDENCIES
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    nodejs \
    yarn \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

# BUILD DIR
WORKDIR /opt/app

# COPY FILES
COPY . .

# INSTALL HEX + REBAR
RUN mix do deps.get, deps.compile, compile

# MIX ENVIRONMENT
RUN \
  mkdir -p /opt/built && \
  mix distillery.release --verbose && \
  cp _build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /opt/built && \
  cd /opt/built && \
  tar -xzf ${APP_NAME}.tar.gz && \
  rm ${APP_NAME}.tar.gz

# CLEAR CACHE
RUN rm -rf /var/cache/* \
    && rm -rf /tmp/*

# DEPLOY RELEASE IMAGE
FROM alpine:${ALPINE_VERSION}

ARG APP_NAME

RUN apk update && \
    apk add --no-cache \
      bash \
      openssl-dev

ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME} \
    DATABASE_URL=${DATABASE_URL}

WORKDIR /opt/app

COPY --from=builder /opt/built .

CMD trap 'exit' INT; /opt/app/bin/${APP_NAME} foreground