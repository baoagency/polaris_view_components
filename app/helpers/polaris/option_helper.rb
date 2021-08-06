# frozen_string_literal: true

module Polaris
  module OptionHelper
    def prepend_option(options, key, value)
      options[key] = [value, options[key]].compact.join(" ")
    end

    def append_option(options, key, value)
      options[key] = [options[key], value].compact.join(" ")
    end
  end
end
