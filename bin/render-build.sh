#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
cd demo
bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
