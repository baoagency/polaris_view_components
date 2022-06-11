module Polaris
  class AutocompleteComponent < Component
    renders_one :text_field, ->(**system_arguments) do
      system_arguments[:data] ||= {}
      prepend_option(system_arguments[:data], :action, "click@window->polaris-popover#hide")

      system_arguments[:input_options] ||= {}
      system_arguments[:input_options][:data] = {
        polaris_autocomplete_target: "input",
        action: %w[
          focus->polaris-autocomplete#onFocus
          blur->polaris-autocomplete#onBlur
          input->polaris-autocomplete#onInput
        ]
      }.deep_merge(system_arguments[:input_options][:data] || {})

      TextFieldComponent.new(**system_arguments)
    end
    renders_many :sections, ->(**system_arguments) do
      Autocomplete::SectionComponent.new(multiple: @multiple, **system_arguments)
    end
    renders_many :options, ->(**system_arguments) do
      Autocomplete::OptionComponent.new(multiple: @multiple, **system_arguments)
    end
    renders_one :empty_state

    def initialize(
      multiple: false,
      url: nil,
      selected: [],
      **system_arguments
    )
      @multiple = multiple
      @url = url
      @selected = selected
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        opts[:data][:controller] = "polaris-autocomplete"
        opts[:data][:polaris_autocomplete_url_value] = @url if @url.present?
        opts[:data][:polaris_autocomplete_multiple_value] = @multiple if @multiple.present?
        opts[:data][:polaris_autocomplete_selected_value] = @selected
      end
    end

    def popover_arguments
      {
        alignment: :left,
        full_width: true,
        inline: false,
        wrapper_arguments: {
          data: {polaris_autocomplete_target: "popover"}
        }
      }
    end

    def option_list_arguments
      {
        data: {polaris_autocomplete_target: "results"}
      }
    end
  end
end
