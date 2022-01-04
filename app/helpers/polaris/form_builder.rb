module Polaris
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::OutputSafetyHelper

    attr_reader :template

    delegate :render, :pluralize, to: :template

    def errors_summary
      return if object.blank?
      return unless object.errors.any?

      model_name = object.class.model_name.human.downcase

      render Polaris::BannerComponent.new(
        title: "There's #{pluralize(object.errors.count, "error")} with this #{model_name}:",
        status: :critical
      ) do
        render(Polaris::ListComponent.new) do |list|
          object.errors.full_messages.each do |error|
            list.item { error.html_safe }
          end
        end
      end
    end

    def error_for(method)
      return if object.blank?
      return unless object.errors.key?(method)

      raw object.errors.full_messages_for(method)&.first
    end

    def polaris_inline_error_for(method, **options, &block)
      error_message = error_for(method)
      return unless error_message

      render(Polaris::InlineErrorComponent.new(**options, &block)) do
        error_message
      end
    end

    def polaris_text_field(method, **options, &block)
      options[:error] ||= error_for(method)
      if options[:error_hidden] && options[:error]
        options[:error] = !!options[:error]
      end
      render Polaris::TextFieldComponent.new(form: self, attribute: method, **options, &block)
    end

    def polaris_select(method, **options, &block)
      options[:error] ||= error_for(method)
      if options[:error_hidden] && options[:error]
        options[:error] = !!options[:error]
      end
      value = object&.public_send(method)
      if value.present?
        options[:selected] = value
      end
      render Polaris::SelectComponent.new(form: self, attribute: method, **options, &block)
    end

    def polaris_check_box(method, **options, &block)
      options[:error] ||= error_for(method)
      if options[:error_hidden] && options[:error]
        options[:error] = !!options[:error]
      end
      render Polaris::CheckboxComponent.new(form: self, attribute: method, **options, &block)
    end

    def polaris_radio_button(method, **options, &block)
      options[:error] ||= error_for(method)
      if options[:error_hidden] && options[:error]
        options[:error] = !!options[:error]
      end
      render Polaris::RadioButtonComponent.new(form: self, attribute: method, **options, &block)
    end

    def polaris_dropzone(method, **options, &block)
      options[:error] ||= error_for(method)
      if options[:error_hidden] && options[:error]
        options[:error] = !!options[:error]
      end
      render Polaris::DropzoneComponent.new(form: self, attribute: method, **options, &block)
    end
  end
end
