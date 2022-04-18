# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../demo/config/environment.rb", __dir__)

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "test_helpers/component_test_helper"
require "pry"
