module Polaris
  # Module to allow shorthand calls for Polaris components
  module ViewHelper
    HELPERS = {
      avatar:                   "Polaris::AvatarComponent",
      badge:                    "Polaris::BadgeComponent",
      banner:                   "Polaris::Banner::Component",
      button:                   "Polaris::ButtonComponent",
      button_group:             "Polaris::ButtonGroupComponent",
      callout_group:            "Polaris::CalloutGroup::Component",
      caption:                  "Polaris::Caption::Component",
      card:                     "Polaris::Card::Component",
      card_header:              "Polaris::CardHeader::Component",
      card_section:             "Polaris::CardSection::Component",
      check_box:                "Polaris::CheckBox::Component",
      choice:                   "Polaris::Choice::Component",
      choice_list:              "Polaris::ChoiceList::Component",
      description_list:         "Polaris::DescriptionList::Component",
      display_text:             "Polaris::DisplayText::Component",
      dropzone:                 "Polaris::Dropzone::Component",
      empty_state:              "Polaris::EmptyState::Component",
      footer_help:              "Polaris::FooterHelpComponent",
      form_layout:              "Polaris::FormLayout::Component",
      form_layout_group:        "Polaris::FormLayoutGroup::Component",
      form_layout_item:         "Polaris::FormLayoutItem::Component",
      heading:                  "Polaris::HeadingComponent",
      icon:                     "Polaris::IconComponent",
      image:                    "Polaris::Image::Component",
      inline_error:             "Polaris::InlineError::Component",
      label:                    "Polaris::Label::Component",
      labelled:                 "Polaris::Labelled::Component",
      layout:                   "Polaris::LayoutComponent",
      link:                     "Polaris::LinkComponent",
      page:                     "Polaris::Page::Component",
      page_actions:             "Polaris::PageActions::Component",
      pagination:               "Polaris::PaginationComponent",
      progress_bar:             "Polaris::ProgressBar::Component",
      radio_button:             "Polaris::RadioButton::Component",
      select:                   "Polaris::Select::Component",
      shopify_navigation:       "Polaris::ShopifyNavigation::Component",
      stack:                    "Polaris::Stack::Component",
      stack_item:               "Polaris::StackItem::Component",
      sub_heading:              "Polaris::SubHeading::Component",
      spinner:                  "Polaris::SpinnerComponent",
      text_container:           "Polaris::TextContainer::Component",
      text_field:               "Polaris::TextField::Component",
      text_style:               "Polaris::TextStyle::Component",
      thumbnail:                "Polaris::Thumbnail::Component",
      visually_hidden:          "Polaris::VisuallyHiddenComponent",
    }.freeze

    HELPERS.each do |name, component|
      define_method "polaris_#{name}" do |*args, **kwargs, &block|
        render component.constantize.new(*args, **kwargs), &block
      end
    end

    def polaris_icon_source(name)
      path = ViewComponents::Engine.root.join("app", "assets", "icons", "polaris", "#{name}.svg")
      file = File.read(path)
      doc = Nokogiri::HTML::DocumentFragment.parse(file)
      svg = doc.at_css 'svg'
      svg[:class] = "Polaris-Icon__Svg"
      svg[:focusable] = false
      svg[:"aria-hidden"] = true
      doc.to_html.html_safe
    end

    def polaris_action(*args, **kwargs)
      Polaris.action(*args, **kwargs)
    end

    def polaris_complex_action(*args, **kwargs)
      Polaris.complex_action(*args, **kwargs)
    end
  end
end
