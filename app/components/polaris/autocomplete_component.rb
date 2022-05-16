module Polaris
  class AutocompleteComponent < Component
    renders_one :text_field, ->(**system_arguments) do
      system_arguments[:data] ||= {}
      prepend_option(system_arguments[:data], :action, %w[
        click->polaris-autocomplete#toggle
        click@window->polaris-popover#hide
      ])

      system_arguments[:input_options] ||= {}
      system_arguments[:input_options][:data] ||= {}
      system_arguments[:input_options][:data][:polaris_autocomplete_target] = "input"

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
      @select_event_ref = "autocomplete-select-ref-#{SecureRandom.uuid}"
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        opts[:data][:controller] = "polaris-autocomplete"
        if @url.present?
          opts[:data][:polaris_autocomplete_url_value] = @url
        end
        opts[:data][:polaris_autocomplete_selected_value] = @selected
        opts[:data][:polaris_autocomplete_select_event_ref_value] = @select_event_ref
      end
    end

    def popover_arguments
      {
        alignment: :left,
        full_width: true,
        inline: false,
        wrapper_arguments: {
          data: { polaris_autocomplete_target: "popover" }
        }
      }
    end

    def option_list_arguments
      {
        data: {
          target: "results",
          controller: "polaris-autocomplete-option-list",
          polaris_autocomplete_option_list_select_event_ref_value: @select_event_ref
        }
      }
    end
  end
end
