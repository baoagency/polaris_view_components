module Polaris
  # Module to allow shorthand calls for Polaris components
  module ViewHelper
    # standard:disable Layout/HashAlignment
    POLARIS_HELPERS = {
      action_list:              "Polaris::ActionListComponent",
      autocomplete:             "Polaris::AutocompleteComponent",
      autocomplete_section:     "Polaris::Autocomplete::SectionComponent",
      autocomplete_option:      "Polaris::Autocomplete::OptionComponent",
      avatar:                   "Polaris::AvatarComponent",
      badge:                    "Polaris::BadgeComponent",
      banner:                   "Polaris::BannerComponent",
      bleed:                    "Polaris::BleedComponent",
      box:                      "Polaris::BoxComponent",
      button:                   "Polaris::ButtonComponent",
      button_group:             "Polaris::ButtonGroupComponent",
      callout_card:             "Polaris::CalloutCardComponent",
      caption:                  "Polaris::CaptionComponent",
      card:                     "Polaris::CardComponent",
      card_section:             "Polaris::Card::SectionComponent",
      checkbox:                 "Polaris::CheckboxComponent",
      check_box:                "Polaris::CheckboxComponent",
      choice_list:              "Polaris::ChoiceListComponent",
      collapsible:              "Polaris::CollapsibleComponent",
      data_table:               "Polaris::DataTableComponent",
      description_list:         "Polaris::DescriptionListComponent",
      display_text:             "Polaris::DisplayTextComponent",
      divider:                  "Polaris::DividerComponent",
      dropzone:                 "Polaris::DropzoneComponent",
      empty_search_results:     "Polaris::EmptySearchResultsComponent",
      empty_state:              "Polaris::EmptyStateComponent",
      exception_list:           "Polaris::ExceptionListComponent",
      footer_help:              "Polaris::FooterHelpComponent",
      form_layout:              "Polaris::FormLayoutComponent",
      frame:                    "Polaris::FrameComponent",
      filters:                  "Polaris::FiltersComponent",
      heading:                  "Polaris::HeadingComponent",
      horizontal_grid:          "Polaris::HorizontalGridComponent",
      horizontal_stack:         "Polaris::HorizontalStackComponent",
      icon:                     "Polaris::IconComponent",
      index_table:              "Polaris::IndexTableComponent",
      inline_code:              "Polaris::InlineCodeComponent",
      inline:                   "Polaris::InlineComponent",
      inline_error:             "Polaris::InlineErrorComponent",
      keyboard_key:             "Polaris::KeyboardKeyComponent",
      layout:                   "Polaris::LayoutComponent",
      link:                     "Polaris::LinkComponent",
      list:                     "Polaris::ListComponent",
      modal:                    "Polaris::ModalComponent",
      modal_section:            "Polaris::Modal::SectionComponent",
      navigation:               "Polaris::NavigationComponent",
      navigation_list:          "Polaris::NavigationListComponent",
      option_list:              "Polaris::OptionListComponent",
      page:                     "Polaris::PageComponent",
      page_actions:             "Polaris::PageActionsComponent",
      pagination:               "Polaris::PaginationComponent",
      placeholder:              "Polaris::PlaceholderComponent",
      progress_bar:             "Polaris::ProgressBarComponent",
      popover:                  "Polaris::PopoverComponent",
      radio_button:             "Polaris::RadioButtonComponent",
      resource_list:            "Polaris::ResourceListComponent",
      resource_item:            "Polaris::ResourceItemComponent",
      select:                   "Polaris::SelectComponent",
      setting_toggle:           "Polaris::SettingToggleComponent",
      shopify_navigation:       "Polaris::ShopifyNavigationComponent",
      stack:                    "Polaris::StackComponent",
      stack_item:               "Polaris::Stack::ItemComponent",
      subheading:               "Polaris::SubheadingComponent",
      scrollable:               "Polaris::ScrollableComponent",
      spinner:                  "Polaris::SpinnerComponent",
      skeleton_body_text:       "Polaris::SkeletonBodyTextComponent",
      skeleton_display_text:    "Polaris::SkeletonDisplayTextComponent",
      skeleton_page:            "Polaris::SkeletonPageComponent",
      skeleton_thumbnail:       "Polaris::SkeletonThumbnailComponent",
      spacer:                   "Polaris::SpacerComponent",
      tabs:                     "Polaris::TabsComponent",
      tag:                      "Polaris::TagComponent",
      text:                     "Polaris::TextComponent",
      text_container:           "Polaris::TextContainerComponent",
      text_field:               "Polaris::TextFieldComponent",
      text_style:               "Polaris::TextStyleComponent",
      thumbnail:                "Polaris::ThumbnailComponent",
      toast:                    "Polaris::ToastComponent",
      tooltip:                  "Polaris::TooltipComponent",
      vertical_stack:           "Polaris::VerticalStackComponent",
      visually_hidden:          "Polaris::VisuallyHiddenComponent"
    }.freeze
    # standard:enable Layout/HashAlignment
    POLARIS_HELPERS.each do |name, component|
      define_method :"polaris_#{name}" do |*args, **kwargs, &block|
        render component.constantize.new(*args, **kwargs), &block
      end
    end

    POLARIS_TEXT_STYLES = %i[subdued strong positive negative code].freeze
    POLARIS_TEXT_STYLES.each do |name|
      define_method :"polaris_text_#{name}" do |**kwargs, &block|
        polaris_text_style(variation: name, **kwargs, &block)
      end
    end

    def polaris_icon_source(name)
      paths = [
        ViewComponents::Engine.root.join("app", "assets", "icons", "polaris", "#{name}.svg"),
        Rails.root.join("app", "assets", "icons", "polaris", "#{name}.svg")
      ]

      path = paths.find { |path| File.exist?(path) }
      return unless path

      file = File.read(path)
      doc = Nokogiri::HTML::DocumentFragment.parse(file)
      svg = doc.at_css "svg"
      svg[:class] = "Polaris-Icon__Svg"
      svg[:focusable] = false
      svg[:"aria-hidden"] = true
      doc.to_html.html_safe
    end

    def polaris_html_classes
      "Polaris-Summer-Editions-2023"
    end

    def polaris_html_styles
      %(--pc-frame-global-ribbon-height:0px; --pc-frame-offset:0px;)
    end

    def polaris_body_styles
      %(background-color: var(--p-color-bg-app);color: var(--p-color-text);)
    end
  end
end
