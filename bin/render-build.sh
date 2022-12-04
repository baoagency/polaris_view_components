#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
cd demo
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails tmp:cache:clear
