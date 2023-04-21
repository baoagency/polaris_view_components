module Polaris
  class TooltipComponent < Polaris::Component
    def initialize(
      text: nil,
      **system_arguments
    )
      @text = text
      @system_arguments = system_arguments

      system_arguments[:data] ||= {}
      prepend_option(system_arguments[:data], :controller, 'polaris-tooltip')
      prepend_option(system_arguments[:data], :action,
                     'mouseenter->polaris-tooltip#show mouseleave->polaris-tooltip#hide')
    end
  end
end
