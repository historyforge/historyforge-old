#!/bin/bash
set -e

echo "--> Precompiling assets"
bundle exec rake assets:precompile

echo "--> Migrating database"
bundle exec rails db:migrate
