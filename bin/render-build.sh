#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Clear existing precompiled assets
bundle exec rails assets:clobber

# Precompile assets
RAILS_ENV=production bundle exec rails assets:precompile

# Clear cache
bundle exec rails tmp:clear

# Compile WebPacker if you're using it (remove if not applicable)
# RAILS_ENV=production bundle exec rails webpacker:compile

# Run database migrations
bundle exec rails db:migrate

# Restart application server (optional, but can help with some issues)
# touch tmp/restart.txt