# frozen_string_literal: true

module Polaris
  module ComponentTestHelpers
    include ViewComponent::TestHelpers
    include Polaris::ViewHelper
    include Polaris::ActionHelper
    include Polaris::ConditionalHelper
  end
end
