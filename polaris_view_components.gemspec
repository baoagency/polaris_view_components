require_relative "lib/polaris/view_components/version"

Gem::Specification.new do |spec|
  spec.name        = "polaris_view_components"
  spec.version     = Polaris::ViewComponents::VERSION::STRING
  spec.authors     = ["Dan Gamble", "Kirill Platonov"]
  spec.email       = ["dan@dangamble.co.uk"]

  spec.homepage    = "https://github.com/baoagency/polaris-view-components"
  spec.summary     = "ViewComponents for Polaris Design System"
  spec.license     = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files       = Dir["lib/**/*", "app/**/*", "LICENSE.txt", "README.md"]

  spec.add_runtime_dependency     "rails", ">= 5.0.0"
  spec.add_runtime_dependency     "view_component", [">= 2.0.0", "< 2.35.0"]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "foreman"
  spec.add_development_dependency "capybara", "~> 3"
end
