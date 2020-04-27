#!/bin/bash

str=`date -Ins | md5sum`
name=${str:0:10}

mix deps.get --force
mix ecto.setup
mix utils.seed