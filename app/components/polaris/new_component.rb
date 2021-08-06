# frozen_string_literal: true

module Polaris
  class NewComponent < ViewComponent::Base
    include ClassNameHelper
    include FetchOrFallbackHelper
    include OptionHelper
    include ViewHelper
  end
end
