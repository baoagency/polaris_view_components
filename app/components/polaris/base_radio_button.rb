module Polaris
  class BaseRadioButton < Polaris::Component
    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      checked: nil,
      disabled: false,
      value: nil,
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @checked = checked
      @disabled = disabled
      @value = value
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:disabled] = true if @disabled
        opts[:aria] ||= {}
        opts[:class] = opts.delete(:classes)

        if @form.present? && @attribute.present?
          unless @checked.nil?
            opts[:aria][:checked] = !!@checked
            opts[:checked] = !!@checked
          end
        else
          opts[:aria][:checked] = !!@checked
          opts[:checked] = !!@checked
        end
      end
    end

    def call
      if @form.present? && @attribute.present?
        @form.radio_button(@attribute, @value, system_arguments)
      else
        radio_button_tag(@name, @value, @checked, system_arguments)
      end
    end
  end
end
