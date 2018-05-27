#!/bin/bash

echo "--> Installing geo packages"
apt-get update -qq && apt-get install -y ruby-mapscript  \
     && rm -rf /var/lib/apt/lists/*

echo "--> Compiling assets"
bundle exec rails assets:precompile

echo "--> Migrating database"
bundle exec rails db:migrate
