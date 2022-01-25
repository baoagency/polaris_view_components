# frozen_string_literal: true

module Polaris
  class CollapsibleComponent < Polaris::Component
    def initialize(
      expand_on_print: false,
      open: false,
      **system_arguments
    )
      @expand_on_print = expand_on_print
      @open = open
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        prepend_option(opts[:data], :controller, "polaris-collapsible")
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Collapsible",
          "Polaris-Collapsible--isFullyClosed": !@open,
          "Polaris-Collapsible--expandOnPrint": @expand_on_print
        )
        opts[:style] = class_names(
          @open ? "max-height: none;" : "max-height: 0px;",
          @open ? "overflow: visible;" : "overflow: hidden;"
        )
      end
    end

    def call
      render(Polaris::BaseComponent.new(**system_arguments)) { content }
    end
  end
end
