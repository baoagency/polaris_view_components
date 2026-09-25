# frozen_string_literal: true

module Polaris
  class CollapsibleComponent < Polaris::Component
    def initialize(
      expand_on_print: false,
      open: false,
      title: nil,
      **system_arguments
    )
      @expand_on_print = expand_on_print
      @open = open
      @title = title
      @system_arguments = system_arguments
      @system_arguments[:id] ||= "polaris-collapsible-#{SecureRandom.hex(4)}" if @title.present?
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
      collapsible = render(Polaris::BaseComponent.new(**system_arguments)) { content }
      return collapsible if @title.blank?

      tag.div { safe_join([trigger, collapsible]) }
    end

    private

    def trigger
      id = @system_arguments[:id]

      polaris_button(
        plain: true,
        disclosure: :down,
        classes: "Polaris-Collapsible__Trigger",
        aria: {expanded: @open, controls: id},
        data: {
          controller: "polaris",
          target: "##{id}",
          action: "polaris#toggleCollapsible"
        }
      ) { @title }
    end
  end
end
