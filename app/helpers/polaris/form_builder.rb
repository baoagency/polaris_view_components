module Polaris
  class FormBuilder < ActionView::Helpers::FormBuilder
    def polaris_text_field(method, **options, &block)
      options[:error] ||= error_for(method)
      if options[:error_hidden] && options[:error]
        options[:error] = !!options[:error]
      end
      @template.render(
        Polaris::TextFieldComponent.new(form: self, attribute: method, **options, &block)
      )
    end

    def error_for(method)
      return if object.blank?
      return unless object.errors.key?(method)
      object.errors.full_messages_for(method)&.first
    end
  end
end
