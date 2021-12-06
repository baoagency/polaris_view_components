class Polaris::TopBar::UserMenuComponent < Polaris::NewComponent
  renders_one :avatar, Polaris::AvatarComponent

  def initialize(name:, detail:, **system_arguments)
    @name = name
    @detail = detail
    @system_arguments = system_arguments
  end
end
