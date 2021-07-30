# frozen_string_literal: true

module Polaris
  class NewComponent < ViewComponent::Base
    include ClassNameHelper
    include FetchOrFallbackHelper
    include ViewHelper
  end
end
