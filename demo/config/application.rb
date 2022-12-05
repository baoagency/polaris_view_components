require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_job/railtie"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "active_storage/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Demo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Store uploaded files on the local file system in a temporary directory.
    config.active_storage.service = :test

    # Don't generate system test files.
    config.generators.system_tests = nil

    # ViewComponent
    config.view_component.preview_paths << Rails.root.join("app/previews").to_s
    config.view_component.view_component_path = Rails.root.join("../app/components").to_s
    config.view_component.preview_controller = "PreviewController"
    config.view_component.show_previews = true

    # Lookbook
    config.lookbook.project_name = "Polaris ViewComponents"
  end
end
