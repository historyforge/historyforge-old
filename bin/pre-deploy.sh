#!/bin/bash
set -e
bundle exec rails db:migrate db:seed
bundle exec rails assets:precompile

