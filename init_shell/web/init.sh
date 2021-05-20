#!/bin/bash
cd /rails-app
rm -f tmp/pids/*.pid
bundle install
yarn install
bundle exec rails s -b "0.0.0.0"