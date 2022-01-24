# frozen_string_literal: true

module Polaris
  class ExceptionListComponent < Polaris::Component
    renders_many :items, Polaris::ExceptionList::ItemComponent

    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = "ul"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ExceptionList"
      )
    end

    def renders?
      items.any?
    end
  end
end
