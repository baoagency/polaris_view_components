# frozen_string_literal: true

module Polaris
  class Component < ViewComponent::Base
    include ClassNameHelper
    include FetchOrFallbackHelper
    include OptionHelper
    include ViewHelper
  end
end
