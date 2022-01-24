# frozen_string_literal: true

module Polaris
  module ComponentTestHelpers
    include ActionView::Helpers::TagHelper
    include ViewComponent::TestHelpers
    include Polaris::ViewHelper
  end
end
