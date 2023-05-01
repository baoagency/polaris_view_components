class LayoutComponentPreview < ViewComponent::Preview
  # Use to have a single section on its own in a full-width container. Use for simple pages and as a container for banners and other full-width content.
  def one_column_layout
  end

  # Use to follow a normal section with a secondary section to create a 2/3 + 1/3 layout on detail pages (such as individual product or order pages). Can also be used on any page that needs to structure a lot of content. This layout stacks the columns on small screens.
  def two_columns_with_primary_and_secondary_widths
  end

  # Use to create a ½ + ½ layout. Can be used to display content of equal importance. This layout will stack the columns on small screens.
  def two_columns_with_equal_width
  end

  # Use to create a ⅓ + ⅓ + ⅓ layout. Can be used to display content of equal importance. This layout will stack the columns on small screens.
  def three_columns_with_equal_width
  end

  def four_columns_with_equal_width
  end

  # Use for settings pages. When settings are grouped thematically in annotated sections, the title and description on each section helps merchants quickly find the setting they’re looking for.
  def annotated_layout
  end

  # Use for settings pages. When settings are grouped thematically in annotated sections, the title and description on each section helps merchants quickly find the setting they’re looking for.
  def annotated_layout_with_sections
  end

  # Use for settings pages that need a banner or other content at the top.
  def annotated_layout_with_banner_at_the_top
  end

  def mixed_layout
  end
end
