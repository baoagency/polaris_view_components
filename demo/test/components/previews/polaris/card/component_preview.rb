class Polaris::Card::ComponentPreview < ViewComponent::Preview
  def default
    render Polaris::Card::Component.new(title: "Card Title") do
      tag.p "Card Body"
    end
  end
end
