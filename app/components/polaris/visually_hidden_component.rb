# frozen_string_literal: true

module Polaris
  class VisuallyHiddenComponent < Polaris::Component
    def call
      content_tag(:span, content, class: "Polaris-VisuallyHidden")
    end
  end
end
