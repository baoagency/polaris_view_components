class AvatarComponentPreview < ViewComponent::Preview
  # Avatar Component
  # ------------
  # Avatars are used to show a thumbnail representation of an individual or business in the interface.
  #
  # @param customer toggle "Whether the avatar is for a customer"
  # @param name text "The name of the person"
  # @param size select "Size of avatar" {{Polaris::AvatarComponent::SIZE_MAPPINGS.keys}}
  # @param shape select "Shape of avatar" {{Polaris::AvatarComponent::SHAPE_MAPPINGS.keys}}
  # @param source url "URL of the avatar image which falls back to default if blank"
  # @param initials text "Initials of person to display"
  def default(
    customer: true,
    name: "Farrah",
    size: :medium,
    shape: :round,
    source: "https://www.redditstatic.com/desktop2x/img/favicon/apple-icon-180x180.png",
    initials: "AK"
  )
    render_with_template(
      locals: {
        customer: customer,
        name: name,
        size: size,
        shape: shape,
        source: source,
        initials: initials
      }
    )
  end

  # @param customer toggle "Whether the avatar is for a customer"
  # @param name text "The name of the person"
  # @param size select "Size of avatar" {{Polaris::AvatarComponent::SIZE_MAPPINGS.keys}}
  def basic(customer: true, name: "Farrah", size: :medium)
    render_with_template(
      locals: {
        customer: customer,
        name: name,
        size: size
      }
    )
  end

  # @param size select "Size of avatar" {{Polaris::AvatarComponent::SIZE_MAPPINGS.keys}}
  def extra_small(size: :extra_small)
    render_with_template(
      locals: {
        size: size
      }
    )
  end

  # @param shape select "Shape of avatar" {{Polaris::AvatarComponent::SHAPE_MAPPINGS.keys}}
  def square(shape: :square)
    render_with_template(
      locals: {
        shape: shape
      }
    )
  end

  # @param initials text "Initials of person to display"
  def initials(initials: "AK")
    render_with_template(
      locals: {
        initials: initials
      }
    )
  end

  # @param source url "URL of the avatar image which falls back to default if blank"
  def image(source: "https://www.redditstatic.com/desktop2x/img/favicon/apple-icon-180x180.png")
    render_with_template(
      locals: {
        source: source
      }
    )
  end
end
