class Polaris::TopBar::UserMenuComponent < Polaris::Component
  renders_one :avatar, Polaris::AvatarComponent

  def initialize(name:, detail: nil, show_avatar_first: false, **system_arguments)
    @name = name
    @detail = detail
    @show_avatar_first = show_avatar_first
    @system_arguments = system_arguments
  end
end
