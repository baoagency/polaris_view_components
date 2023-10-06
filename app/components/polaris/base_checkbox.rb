module Polaris
  class BaseCheckbox < Polaris::Component
    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      checked: false,
      disabled: false,
      mulitple: false,
      value: "1",
      unchecked_value: "0",
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @checked = checked
      @disabled = disabled
      @value = value
      @unchecked_value = unchecked_value
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:checked] = true if @checked
        opts[:disabled] = true if @disabled
        opts[:multiple] = true if @multiple
        opts[:aria] ||= {}
        opts[:aria][:checked] = @checked
        if indeterminate?
          @system_arguments[:indeterminate] = true
          @system_arguments[:aria][:checked] = "mixed"
        end
        opts[:class] = opts.delete(:classes)
        opts[:form] = @form if @form.present? && @attribute.blank?
      end
    end

    def indeterminate?
      @checked == :indeterminate
    end

    def call
      if @form.present? && @attribute.present?
        @form.check_box(@attribute, system_arguments, @value, @unchecked_value)
      else
        check_box_tag(@name, @value, @checked, system_arguments)
      end
    end
  end
end
