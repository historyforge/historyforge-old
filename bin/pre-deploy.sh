#!/bin/bash
set -e
bundle exec rails db:migrate
bundle exec rails assets:precompile

