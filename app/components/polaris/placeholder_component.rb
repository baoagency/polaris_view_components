module Polaris
  class PlaceholderComponent < Polaris::Component
    def initialize(height: "auto", width: "auto", label: nil, show_border: false)
      @label = label
      border = show_border ? "1px dashed var(--p-color-bg-success-subdued)" : "none"
      @system_arguments = {
        tag: :div,
        style: [
          "background-color: var(--p-color-text-info)",
          "color: #fff",
          "width: #{width}",
          "height: #{height}",
          "display: flex",
          "align-items: center",
          "justify-content: center",
          "border-inline-start: #{border}"
        ].join(";")
      }
    end

    def call
      if @label.present?
        render(Polaris::BaseComponent.new(**@system_arguments)) do
          render(Polaris::InlineComponent.new(align: :center)) do
            tag.div(style: "color: #fff;") do
              render(Polaris::TextComponent.new(as: :h2, variant: :bodyMd)) do
                @label
              end
            end
          end
        end
      else
        render(Polaris::BaseComponent.new(**@system_arguments)) { content }
      end
    end
  end
end
