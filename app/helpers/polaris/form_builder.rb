module Polaris
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template

    delegate :render, :pluralize, to: :template

    def polaris_text_field(method, **options, &block)
      options[:error] ||= error_for(method)
      if options[:error_hidden] && options[:error]
        options[:error] = !!options[:error]
      end
      render Polaris::TextFieldComponent.new(
        form: self,
        attribute: method,
        **options,
        &block
      )
    end

    def error_for(method)
      return if object.blank?
      return unless object.errors.key?(method)

      object.errors.full_messages_for(method)&.first
    end

    def errors_summary
      return if object.blank?
      return unless object.errors.any?

      model_name = object.class.model_name.human.downcase

      render Polaris::BannerComponent.new(
        title: "There's #{pluralize(object.errors.count, "error")} with this #{model_name}:",
        status: :critical,
      ) do
        render(Polaris::ListComponent.new) do |list|
          object.errors.each do |error|
            list.item { error.full_message }
          end
        end
      end
    end
  end
end
