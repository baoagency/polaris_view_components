module Polaris
  # Module to allow shorthand calls for Polaris components
  module ViewHelper
    HELPERS = {
      badge:                    "Polaris::Badge::Component",
      banner:                   "Polaris::Banner::Component",
      button:                   "Polaris::Button::Component",
      button_group:             "Polaris::ButtonGroup::Component",
      callout_group:            "Polaris::CalloutGroup::Component",
      caption:                  "Polaris::Caption::Component",
      card:                     "Polaris::Card::Component",
      card_header:              "Polaris::CardHeader::Component",
      card_section:             "Polaris::CardSection::Component",
      checkbox:                 "Polaris::CheckBox::Component",
      choice:                   "Polaris::Choice::Component",
      choice_list:              "Polaris::ChoiceList::Component",
      description_list:         "Polaris::DescriptionList::Component",
      display_text:             "Polaris::DisplayText::Component",
      dropzone:                 "Polaris::Dropzone::Component",
      empty_state:              "Polaris::EmptyState::Component",
      footer_help:              "Polaris::FooterHelp::Component",
      form_layout:              "Polaris::FormLayout::Component",
      form_layout_group:        "Polaris::FormLayoutGroup::Component",
      form_layout_item:         "Polaris::FormLayoutItem::Component",
      heading:                  "Polaris::Heading::Component",
      icon:                     "Polaris::Icon::Component",
      image:                    "Polaris::Image::Component",
      inline_error:             "Polaris::InlineError::Component",
      label:                    "Polaris::Label::Component",
      labelled:                 "Polaris::Labelled::Component",
      layout:                   "Polaris::Layout::Component",
      layout_annotated_section: "Polaris::LayoutAnnotatedSection::Component",
      layout_section:           "Polaris::LayoutSection::Component",
      link:                     "Polaris::Link::Component",
      page:                     "Polaris::Page::Component",
      page_actions:             "Polaris::PageActions::Component",
      progress_bar:             "Polaris::ProgressBar::Component",
      radio_button:             "Polaris::RadioButton::Component",
      select:                   "Polaris::Select::Component",
      shopify_navigation:       "Polaris::ShopifyNavigation::Component",
      stack:                    "Polaris::Stack::Component",
      stack_item:               "Polaris::StackItem::Component",
      sub_heading:              "Polaris::SubHeading::Component",
      text_container:           "Polaris::TextContainer::Component",
      text_field:               "Polaris::TextField::Component",
      text_style:               "Polaris::TextStyle::Component",
      thumbnail:                "Polaris::Thumbnail::Component",
      visually_hidden:          "Polaris::VisuallyHidden::Component",
    }.freeze

    HELPERS.each do |name, component|
      define_method "polaris_#{name}" do |*args, **kwargs, &block|
        render component.constantize.new(*args, **kwargs), &block
      end
    end
  end
end
