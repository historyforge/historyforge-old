#!/bin/bash

echo "--> Precompiling assets"
bundle exec rake assets:precompile

echo "--> Migrating database"
bundle exec rake db:migrate
