require "polaris/view_components/version"
require "polaris/view_components/engine"

require 'polaris/action'
require 'polaris/complex_action'

require 'polaris/helpers'
require 'polaris/helpers/action_helper'
require 'polaris/helpers/conditional_helper'

module Polaris
  extend Helpers
  extend Helpers::ActionHelper
  extend Helpers::ConditionalHelper

  module ViewComponents
  end
end
