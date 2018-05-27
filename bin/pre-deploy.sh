#!/bin/bash

echo "--> Migrating database"
bundle exec rake db:migrate
