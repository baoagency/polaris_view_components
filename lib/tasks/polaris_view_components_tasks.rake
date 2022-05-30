namespace :polaris_view_components do
  desc "Setup Polaris::ViewComponents for the app"
  task :install do
    system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/install.rb", __dir__)}"
  end
end
