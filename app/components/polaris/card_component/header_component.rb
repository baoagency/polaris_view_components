module Polaris
  class CardComponent
    class HeaderComponent < Polaris::NewComponent
      include Polaris::Helpers::ActionHelper

      def initialize(
        title: "",
        actions: [],
        **system_arguments
      )
        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Card__Header",
        )

        @title = title
        @actions = actions.map { |a| a.merge(plain: true) }
      end

      def simple?
        content.blank? && @actions.blank?
      end
    end
  end
end
