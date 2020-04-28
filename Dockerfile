# IMAGe
FROM elixir:1.10

# MAINTAINER
LABEL Maintainer="Marcio Camello <mac3designer@gmail.com>" \
      Description="BankAPI Elixir image with Phoenix Framework"

# ADDING DEPENDENCIES
RUN apt-get update && apt-get install git inotify-tools make gcc libc-dev -y

# MIX_ENV
ENV MIX_ENV=prod

# APPLICATION DIRECTORY
RUN mkdir /app
WORKDIR /app

# INSTALL MIX DEPENDENCIES
RUN mix local.hex --force && \
    mix local.rebar --force

# PORT
ENV REPLACE_OS_VARS=true
ENV HTTP_PORT=4001 BEAM_PORT=14001 ERL_EPMD_PORT=24001
EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT

# CLEAR CACHE
RUN rm -rf /var/cache/* \
    && rm -rf /tmp/*

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# START
CMD [ "bash", "-c", "/root/entrypoint.sh" ]