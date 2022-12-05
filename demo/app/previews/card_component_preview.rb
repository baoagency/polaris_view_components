class CardComponentPreview < ViewComponent::Preview
  # Use when you have a simple message to communicate to merchants that doesn’t require any secondary steps.
  def default
  end

  # Use for less important card actions, or actions merchants may do before reviewing the contents of the card. For example, merchants may want to add items to a card containing a long list, or enter a customer’s new address.
  def card_with_header_actions
  end

  # Use footer actions for a card’s most important actions, or actions merchants should do after reviewing the contents of the card. For example, merchants should review the contents of a shipment before an important action like adding tracking information. Footer actions can be left or right aligned with the footerActionAlignment prop.
  def card_with_footer_actions
  end

  # TODO
  # @hidden
  def card_with_multiple_footer_actions
  end

  # Use to present actionable content that is optional or not the primary purpose of the page.
  def card_with_custom_footer_actions
  end

  # Use when a card action will delete merchant data or be otherwise difficult to recover from.
  def card_with_destructive_footer_action
  end

  # Use when you have two related but distinct pieces of information to communicate to merchants. Multiple sections can help break up complicated concepts to make them easier to scan and understand.
  def card_with_multiple_sections
  end

  # Use when you have two related but distinct pieces of information to communicate to merchants that are complex enough to require a title to introduce them.
  def card_with_multiple_titled_sections
  end

  # Use when your card section has actions that apply only to that section.
  def card_section_with_action
  end

  # Use when your card sections need further categorization.
  def card_with_subsection
  end

  # Use when a card action applies only to one section and will delete merchant data or be otherwise difficult to recover from.
  def card_section_with_destructive_action
  end

  # Use to indicate when one of the sections in your card contains inactive or disabled content.
  def card_with_subdued_section
  end

  # Use for content that you want to deprioritize. Subdued cards don’t stand out as much as cards with white backgrounds so don’t use them for information or actions that are critical to merchants.
  def subdued_card_for_secondary_content
  end

  # Use to be able to use custom elements as header content.
  def card_with_separate_header
  end

  # Use as a broad example that includes most props available to card.
  def card_with_all_of_its_elements
  end

  # Use when you need further control over the spacing of your card sections.
  def card_with_flushed_sections
  end

  def unsectioned_content
  end

  def unstyled_section
  end

  def section_with_borders
  end
end
