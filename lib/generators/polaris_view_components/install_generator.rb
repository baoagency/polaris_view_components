# frozen_string_literal: true

require 'rails/generators/active_record'

module PolarisViewComponents
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def add_npm_package
      say "Adding NPM package", :green
      run "yarn add polaris-view-components"
    end

    def add_to_stimulus_controller
      say "Adding import to to Stimulus controller", :green
      dir_path = "app/javascript/controllers"
      empty_directory('app/javascript')
      empty_directory(dir_path)

      file_path = "#{dir_path}/index.js"

      unless File.exist?(file_path)
        copy_file 'stimulus_index.js', file_path
      end

      append_to_file file_path do
        "import { registerPolarisControllers } from \"polaris-view-components\"\nregisterPolarisControllers(Stimulus)"
      end
    end

    def show_readme
      readme 'README'
    end
  end
end
