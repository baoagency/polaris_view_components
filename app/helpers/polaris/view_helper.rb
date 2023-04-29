module Polaris
  # Module to allow shorthand calls for Polaris components
  module ViewHelper
    # standard:disable Layout/HashAlignment
    POLARIS_HELPERS = {
      action_list:              "Polaris::ActionListComponent",
      alpha_stack:              "Polaris::AlphaStackComponent",
      autocomplete:             "Polaris::AutocompleteComponent",
      autocomplete_section:     "Polaris::Autocomplete::SectionComponent",
      autocomplete_option:      "Polaris::Autocomplete::OptionComponent",
      avatar:                   "Polaris::AvatarComponent",
      badge:                    "Polaris::BadgeComponent",
      banner:                   "Polaris::BannerComponent",
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
      navigation:               "Polaris::NavigationComponent",
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
      visually_hidden:          "Polaris::VisuallyHiddenComponent"
    }.freeze
    # standard:enable Layout/HashAlignment
    POLARIS_HELPERS.each do |name, component|
      define_method "polaris_#{name}" do |*args, **kwargs, &block|
        render component.constantize.new(*args, **kwargs), &block
      end
    end

    POLARIS_TEXT_STYLES = %i[subdued strong positive negative code].freeze
    POLARIS_TEXT_STYLES.each do |name|
      define_method "polaris_text_#{name}" do |**kwargs, &block|
        polaris_text_style(variation: name, **kwargs, &block)
      end
    end

    def polaris_icon_source(name)
      path = ViewComponents::Engine.root.join("app", "assets", "icons", "polaris", "#{name}.svg")
      file = File.read(path)
      doc = Nokogiri::HTML::DocumentFragment.parse(file)
      svg = doc.at_css "svg"
      svg[:class] = "Polaris-Icon__Svg"
      svg[:focusable] = false
      svg[:"aria-hidden"] = true
      doc.to_html.html_safe
    end

    def polaris_html_styles
      %(--pc-frame-global-ribbon-height:0px; --pc-frame-offset:0px;)
    end

    def polaris_body_styles
      %(background-color: var(--p-color-bg-app);color: var(--p-color-text);)
    end

    # TODO: Remove this method
    def polaris_inversed_colors
      %(--p-background:rgba(11, 12, 13, 1); --p-background-hovered:rgba(11, 12, 13, 1); --p-background-pressed:rgba(11, 12, 13, 1); --p-background-selected:rgba(11, 12, 13, 1); --p-surface:rgba(32, 33, 35, 1); --p-surface-neutral:rgba(49, 51, 53, 1); --p-surface-neutral-hovered:rgba(49, 51, 53, 1); --p-surface-neutral-pressed:rgba(49, 51, 53, 1); --p-surface-neutral-disabled:rgba(49, 51, 53, 1); --p-surface-neutral-subdued:rgba(68, 71, 74, 1); --p-surface-subdued:rgba(26, 28, 29, 1); --p-surface-disabled:rgba(26, 28, 29, 1); --p-surface-hovered:rgba(47, 49, 51, 1); --p-surface-pressed:rgba(62, 64, 67, 1); --p-surface-depressed:rgba(80, 83, 86, 1); --p-surface-search-field:rgba(47, 49, 51, 1); --p-backdrop:rgba(0, 0, 0, 0.5); --p-overlay:rgba(33, 33, 33, 0.5); --p-shadow-from-dim-light:rgba(255, 255, 255, 0.2); --p-shadow-from-ambient-light:rgba(23, 24, 24, 0.05); --p-shadow-from-direct-light:rgba(255, 255, 255, 0.15); --p-hint-from-direct-light:rgba(185, 185, 185, 0.2); --p-border:rgba(80, 83, 86, 1); --p-border-neutral-subdued:rgba(130, 135, 139, 1); --p-border-hovered:rgba(80, 83, 86, 1); --p-border-disabled:rgba(103, 107, 111, 1); --p-border-subdued:rgba(130, 135, 139, 1); --p-border-depressed:rgba(142, 145, 145, 1); --p-border-shadow:rgba(91, 95, 98, 1); --p-border-shadow-subdued:rgba(130, 135, 139, 1); --p-divider:rgba(69, 71, 73, 1); --p-icon:rgba(166, 172, 178, 1); --p-icon-hovered:rgba(225, 227, 229, 1); --p-icon-pressed:rgba(166, 172, 178, 1); --p-icon-disabled:rgba(84, 87, 90, 1); --p-icon-subdued:rgba(120, 125, 129, 1); --p-text:rgba(227, 229, 231, 1); --p-text-disabled:rgba(111, 115, 119, 1); --p-text-subdued:rgba(153, 159, 164, 1); --p-interactive:rgba(54, 163, 255, 1); --p-interactive-disabled:rgba(38, 98, 182, 1); --p-interactive-hovered:rgba(103, 175, 255, 1); --p-interactive-pressed:rgba(136, 188, 255, 1); --p-icon-interactive:rgba(54, 163, 255, 1); --p-focused:rgba(38, 98, 182, 1); --p-surface-selected:rgba(2, 14, 35, 1); --p-surface-selected-hovered:rgba(7, 29, 61, 1); --p-surface-selected-pressed:rgba(13, 43, 86, 1); --p-icon-on-interactive:rgba(255, 255, 255, 1); --p-text-on-interactive:rgba(255, 255, 255, 1); --p-action-secondary:rgba(77, 80, 83, 1); --p-action-secondary-disabled:rgba(32, 34, 35, 1); --p-action-secondary-hovered:rgba(84, 87, 91, 1); --p-action-secondary-pressed:rgba(96, 100, 103, 1); --p-action-secondary-depressed:rgba(123, 127, 132, 1); --p-action-primary:rgba(0, 128, 96, 1); --p-action-primary-disabled:rgba(0, 86, 64, 1); --p-action-primary-hovered:rgba(0, 150, 113, 1); --p-action-primary-pressed:rgba(0, 164, 124, 1); --p-action-primary-depressed:rgba(0, 179, 136, 1); --p-icon-on-primary:rgba(230, 255, 244, 1); --p-text-on-primary:rgba(255, 255, 255, 1); --p-text-primary:rgba(0, 141, 106, 1); --p-text-primary-hovered:rgba(0, 158, 120, 1); --p-text-primary-pressed:rgba(0, 176, 133, 1); --p-surface-primary-selected:rgba(12, 18, 16, 1); --p-surface-primary-selected-hovered:rgba(40, 48, 44, 1); --p-surface-primary-selected-pressed:rgba(54, 64, 59, 1); --p-border-critical:rgba(227, 47, 14, 1); --p-border-critical-subdued:rgba(227, 47, 14, 1); --p-border-critical-disabled:rgba(131, 23, 4, 1); --p-icon-critical:rgba(218, 45, 13, 1); --p-surface-critical:rgba(69, 7, 1, 1); --p-surface-critical-subdued:rgba(69, 7, 1, 1); --p-surface-critical-subdued-hovered:rgba(68, 23, 20, 1); --p-surface-critical-subdued-pressed:rgba(107, 16, 3, 1); --p-surface-critical-subdued-depressed:rgba(135, 24, 5, 1); --p-text-critical:rgba(233, 128, 122, 1); --p-action-critical:rgba(205, 41, 12, 1); --p-action-critical-disabled:rgba(187, 37, 10, 1); --p-action-critical-hovered:rgba(227, 47, 14, 1); --p-action-critical-pressed:rgba(250, 53, 17, 1); --p-action-critical-depressed:rgba(253, 87, 73, 1); --p-icon-on-critical:rgba(255, 248, 247, 1); --p-text-on-critical:rgba(255, 255, 255, 1); --p-interactive-critical:rgba(253, 114, 106, 1); --p-interactive-critical-disabled:rgba(254, 172, 168, 1); --p-interactive-critical-hovered:rgba(253, 138, 132, 1); --p-interactive-critical-pressed:rgba(253, 159, 155, 1); --p-border-warning:rgba(153, 112, 0, 1); --p-border-warning-subdued:rgba(153, 112, 0, 1); --p-icon-warning:rgba(104, 75, 0, 1); --p-surface-warning:rgba(153, 112, 0, 1); --p-surface-warning-subdued:rgba(77, 59, 29, 1); --p-surface-warning-subdued-hovered:rgba(82, 63, 32, 1); --p-surface-warning-subdued-pressed:rgba(87, 67, 34, 1); --p-text-warning:rgba(202, 149, 0, 1); --p-border-highlight:rgba(68, 157, 167, 1); --p-border-highlight-subdued:rgba(68, 157, 167, 1); --p-icon-highlight:rgba(44, 108, 115, 1); --p-surface-highlight:rgba(0, 105, 113, 1); --p-surface-highlight-subdued:rgba(18, 53, 57, 1); --p-surface-highlight-subdued-hovered:rgba(20, 58, 62, 1); --p-surface-highlight-subdued-pressed:rgba(24, 65, 70, 1); --p-text-highlight:rgba(162, 239, 250, 1); --p-border-success:rgba(0, 135, 102, 1); --p-border-success-subdued:rgba(0, 135, 102, 1); --p-icon-success:rgba(0, 94, 70, 1); --p-surface-success:rgba(0, 94, 70, 1); --p-surface-success-subdued:rgba(28, 53, 44, 1); --p-surface-success-subdued-hovered:rgba(31, 58, 48, 1); --p-surface-success-subdued-pressed:rgba(35, 65, 54, 1); --p-text-success:rgba(88, 173, 142, 1); --p-decorative-one-icon:rgba(255, 186, 67, 1); --p-decorative-one-surface:rgba(142, 102, 9, 1); --p-decorative-one-text:rgba(255, 255, 255, 1); --p-decorative-two-icon:rgba(245, 182, 192, 1); --p-decorative-two-surface:rgba(206, 88, 20, 1); --p-decorative-two-text:rgba(255, 255, 255, 1); --p-decorative-three-icon:rgba(0, 227, 141, 1); --p-decorative-three-surface:rgba(0, 124, 90, 1); --p-decorative-three-text:rgba(255, 255, 255, 1); --p-decorative-four-icon:rgba(0, 221, 218, 1); --p-decorative-four-surface:rgba(22, 124, 121, 1); --p-decorative-four-text:rgba(255, 255, 255, 1); --p-decorative-five-icon:rgba(244, 183, 191, 1); --p-decorative-five-surface:rgba(194, 51, 86, 1); --p-decorative-five-text:rgba(255, 255, 255, 1); --p-border-radius-slim:0.2rem; --p-border-radius-base:0.4rem; --p-border-radius-wide:0.8rem; --p-border-radius-full:50%; --p-card-shadow:0px 0px 5px var(--p-shadow-from-ambient-light), 0px 1px 2px var(--p-shadow-from-direct-light); --p-popover-shadow:-1px 0px 20px var(--p-shadow-from-ambient-light), 0px 1px 5px var(--p-shadow-from-direct-light); --p-modal-shadow:0px 26px 80px var(--p-shadow-from-dim-light), 0px 0px 1px var(--p-shadow-from-dim-light); --p-top-bar-shadow:0 2px 2px -1px var(--p-shadow-from-direct-light); --p-button-drop-shadow:0 1px 0 rgba(0, 0, 0, 0.05); --p-button-inner-shadow:inset 0 -1px 0 rgba(0, 0, 0, 0.2); --p-button-pressed-inner-shadow:inset 0 1px 0 rgba(0, 0, 0, 0.15); --p-override-none:none; --p-override-transparent:transparent; --p-override-one:1; --p-override-visible:visible; --p-override-zero:0; --p-override-loading-z-index:514; --p-button-font-weight:500; --p-non-null-content:""; --p-choice-size:2rem; --p-icon-size:1rem; --p-choice-margin:0.1rem; --p-control-border-width:0.2rem; --p-banner-border-default:inset 0 0.1rem 0 0 var(--p-border-neutral-subdued), inset 0 0 0 0.1rem var(--p-border-neutral-subdued); --p-banner-border-success:inset 0 0.1rem 0 0 var(--p-border-success-subdued), inset 0 0 0 0.1rem var(--p-border-success-subdued); --p-banner-border-highlight:inset 0 0.1rem 0 0 var(--p-border-highlight-subdued), inset 0 0 0 0.1rem var(--p-border-highlight-subdued); --p-banner-border-warning:inset 0 0.1rem 0 0 var(--p-border-warning-subdued), inset 0 0 0 0.1rem var(--p-border-warning-subdued); --p-banner-border-critical:inset 0 0.1rem 0 0 var(--p-border-critical-subdued), inset 0 0 0 0.1rem var(--p-border-critical-subdued); --p-badge-mix-blend-mode:luminosity; --p-thin-border-subdued:0.1rem solid var(--p-border-subdued); --p-text-field-spinner-offset:0.2rem; --p-text-field-focus-ring-offset:-0.4rem; --p-text-field-focus-ring-border-radius:0.7rem; --p-button-group-item-spacing:-0.1rem; --p-duration-1-0-0:100ms; --p-duration-1-5-0:150ms; --p-ease-in:cubic-bezier(0.5, 0.1, 1, 1); --p-ease:cubic-bezier(0.4, 0.22, 0.28, 1); --p-range-slider-thumb-size-base:1.6rem; --p-range-slider-thumb-size-active:2.4rem; --p-range-slider-thumb-scale:1.5; --p-badge-font-weight:400; --p-frame-offset:0px; color: rgb(227, 229, 231);)
    end
  end
end
