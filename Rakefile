require "bundler/setup"

APP_RAKEFILE = File.expand_path("demo/Rakefile", __dir__)
load "rails/tasks/engine.rake"
# Note: statistics.rake is deprecated in Rails 8.1 and removed in 8.2
# load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

task default: :test
task "test:all" => "app:test:all"
task "test:system" => "app:test:system"
