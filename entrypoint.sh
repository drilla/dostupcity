#!/bin/bash

mix deps.get
# mix deps.compile

mix ecto.create
mix ecto.migrate

iex -S mix phx.server