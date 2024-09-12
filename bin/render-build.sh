#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:clobber
bundle exec rails assets:precompile
bundle exec rails tmp:cache:clear
bundle exec rails db:migrate