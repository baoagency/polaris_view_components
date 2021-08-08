module Polaris
  class FormBuilder < ActionView::Helpers::FormBuilder
    def polaris_text_field(method, **options, &block)
      options[:error] ||= errors_for(method)
      @template.render(
        Polaris::TextFieldComponent.new(form: self, attribute: method, **options, &block)
      )
    end

    def errors_for(method)
      return if object.blank?
      return unless object.errors.key?(method)
      object.errors[method].join(', ').html_safe
    end
  end
end
