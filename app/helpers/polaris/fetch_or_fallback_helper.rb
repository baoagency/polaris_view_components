# frozen_string_literal: true

# Polaris::FetchOrFallbackHelper
# A little helper to enable graceful fallbacks
#
# Use this helper to quietly ensure a value is
# one that you expect:
#
# allowed_values    - allowed options for *value*
# given_value       - input being coerced
# fallback          - returned if *given_value* is not included in *allowed_values*
# deprecated_values - deprecated options for *value*. Will warn of deprecation if not in production
#
# fetch_or_fallback([1,2,3], 5, 2) => 2
# fetch_or_fallback([1,2,3], 1, 2) => 1
# fetch_or_fallback([1,2,3], nil, 2) => 2
#
# With deprecations:
# fetch_or_fallback([1,2], 3, 2, deprecated_values: [3]) => 3
# fetch_or_fallback([1,2], nil, 2, deprecated_values: [3]) => 2
module Polaris
  # :nodoc:
  module FetchOrFallbackHelper
    mattr_accessor :fallback_raises, default: true

    InvalidValueError = Class.new(StandardError)

    def fetch_or_fallback(allowed_values, given_value, fallback = nil, deprecated_values: nil, allow_nil: false)
      return if allow_nil && given_value.nil?

      if allowed_values.include?(given_value)
        given_value
      else
        if fallback_raises && ENV["RAILS_ENV"] != "production" && ENV["STORYBOOK"] != "true"
          raise InvalidValueError, <<~MSG
            fetch_or_fallback was called with an invalid value.
            Expected one of: #{allowed_values.inspect}
            Got: #{given_value.inspect}
            This will not raise in production, but will instead fallback to: #{fallback.inspect}
          MSG
        end

        fallback
      end
    end

    def fetch_or_fallback_boolean(given_value, fallback = false)
      if [true, false].include?(given_value)
        given_value
      else
        fallback
      end
    end

    def fetch_or_fallback_nested(allowed_keys, allowed_values, given_value)
      if given_value.is_a?(Hash)
        given_value.each_with_object({}) do |(key, value), hash|
          hash[fetch_or_fallback(allowed_keys, key)] = fetch_or_fallback(allowed_values, value)
        end
      else
        fetch_or_fallback(allowed_values, given_value)
      end
    end
  end
end
