#!/bin/bash

echo "--> Compiling assets"
bundle exec rails assets:precompile

echo "--> Migrating database"
bundle exec rails db:migrate
