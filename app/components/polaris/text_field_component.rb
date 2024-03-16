# frozen_string_literal: true

module Polaris
  class TextFieldComponent < Polaris::Component
    TYPE_DEFAULT = :text
    TYPE_OPTIONS = %i[
      text number email password search tel url date
      datetime_local month time week currency
    ]

    ALIGN_DEFAULT = :default
    ALIGN_MAPPINGS = {
      ALIGN_DEFAULT => "",
      :left => "Polaris-TextField__Input--alignLeft",
      :center => "Polaris-TextField__Input--alignCenter",
      :right => "Polaris-TextField__Input--alignRight"
    }
    ALIGN_OPTIONS = ALIGN_MAPPINGS.keys

    attr_reader :value

    renders_one :prefix, "Affix"
    renders_one :suffix, "Affix"
    renders_one :connected_left
    renders_one :connected_right

    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      value: nil,
      type: TYPE_DEFAULT,
      placeholder: nil,
      maxlength: nil,
      minlength: nil,
      step: 1,
      min: 0,
      max: 1_000_000,
      rows: 2,
      prefix: nil,
      suffix: nil,
      multiline: false,
      show_character_count: false,
      clear_button: false,
      monospaced: false,
      align: ALIGN_DEFAULT,
      label: nil,
      label_hidden: false,
      label_action: nil,
      disabled: false,
      readonly: false,
      required: false,
      help_text: nil,
      error: false,
      clear_errors_on_focus: false,
      wrapper_arguments: {},
      input_options: {},
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @value = value
      @type = fetch_or_fallback(TYPE_OPTIONS, type, TYPE_DEFAULT)
      @placeholder = placeholder
      @maxlength = maxlength
      @minlength = minlength
      @step = step
      @min = min
      @max = max
      @rows = rows
      @prefix = prefix
      @suffix = suffix
      @multiline = multiline
      @show_character_count = show_character_count
      @clear_button = clear_button
      @monospaced = monospaced
      @align_class = ALIGN_MAPPINGS[fetch_or_fallback(ALIGN_OPTIONS, align, ALIGN_DEFAULT)]
      @label = label
      @label_hidden = label_hidden
      @label_action = label_action
      @disabled = disabled
      @readonly = readonly
      @required = required
      @help_text = help_text
      @error = error
      @clear_errors_on_focus = clear_errors_on_focus
      @wrapper_arguments = wrapper_arguments
      @input_options = input_options
      @system_arguments = system_arguments
    end

    def wrapper_arguments
      {
        form: @form,
        attribute: @attribute,
        name: @name,
        label: @label,
        label_hidden: @label_hidden,
        label_action: @label_action,
        required: @required,
        help_text: @help_text,
        error: @error,
        classes: "polaris-text-field-wrapper"
      }.deep_merge(@wrapper_arguments)
    end

    def system_arguments
      {
        tag: "div",
        data: {
          polaris_text_field_has_value_class: "Polaris-TextField--hasValue",
          polaris_text_field_clear_button_hidden_class: "Polaris-TextField__Hidden"
        }
      }.deep_merge(@system_arguments).tap do |opts|
        opts[:classes] = class_names(
          opts[:classes],
          "Polaris-TextField",
          "Polaris-TextField--disabled": @disabled,
          "Polaris-TextField--readOnly": @readonly,
          "Polaris-TextField--error": @error,
          "Polaris-TextField--hasValue": @value.present?,
          "Polaris-TextField--multiline": @multiline
        )
        prepend_option(opts[:data], :controller, "polaris-text-field")
        if @show_character_count
          opts[:data][:polaris_text_field_label_template_value] = character_count.label_template
          opts[:data][:polaris_text_field_text_template_value] = character_count.text_template
        end
      end
    end

    def input_options
      default_options = {
        value: @value,
        disabled: @disabled,
        readonly: @readonly,
        required: @required,
        placeholder: @placeholder,
        maxlength: @maxlength,
        minlength: @minlength,
        data: {
          polaris_text_field_target: "input"
        }
      }
      if @type == :number
        default_options.merge!({
          step: @step,
          min: @min,
          max: @max
        })
      end
      if @multiline
        default_options[:rows] = @rows
      end

      default_options.deep_merge(@input_options).compact.tap do |opts|
        opts[:class] = class_names(
          opts[:class],
          "Polaris-TextField__Input",
          @align_class,
          "Polaris-TextField--monospaced": @monospaced,
          "Polaris-TextField__Input--suffixed": @suffix.present?
        )
        if @clear_errors_on_focus
          prepend_option(opts[:data], :action, "click->polaris-text-field#clearErrorMessages")
        end
        prepend_option(opts[:data], :action, "polaris-text-field#syncValue")
      end
    end

    def input
      case @type
      when :text
        @multiline ? "text_area" : "text_field"
      when :tel then "telephone_field"
      when :currency then "text_field"
      else
        "#{@type}_field"
      end
    end

    def input_tag
      "#{input}_tag"
    end

    def character_count
      @character_count ||= CharacterCount.new(text_field: self, max_length: @maxlength)
    end

    def render_number_buttons?
      @type == :number && !@disabled
    end

    class Affix < Polaris::Component
      def initialize(icon: nil)
        @icon = icon
      end

      def call
        if @icon.present?
          render Polaris::IconComponent.new(name: @icon)
        else
          content
        end
      end
    end
  end
end
