APPLICATION_LAYOUT_PATH = Rails.root.join("app/views/layouts/application.html.erb")
IMPORTMAP_BINSTUB = Rails.root.join("bin/importmap")
IMPORTMAP_CONFIG_PATH = Rails.root.join("config/importmap.rb")
STIMULUS_PATH = Rails.root.join("app/javascript/controllers/index.js")

if APPLICATION_LAYOUT_PATH.exist?
  say "Add Polaris styles in application layout"
  insert_into_file APPLICATION_LAYOUT_PATH.to_s, "\n    <%= stylesheet_link_tag \"polaris_view_components\" %>", before: /\s*<\/head>/

  if File.read(APPLICATION_LAYOUT_PATH).include?("<body>")
    say "Add Polaris classes and inline styles for <html> in application layout"
    gsub_file APPLICATION_LAYOUT_PATH.to_s, "<html", "<html class=\"<%= polaris_html_classes %>\" style=\"<%= polaris_html_styles %>\""

    say "Add Polaris inline styles for <body> in application layout"
    gsub_file APPLICATION_LAYOUT_PATH.to_s, "<body>", "<body style=\"<%= polaris_body_styles %>\">"
  else
    say "<body> tag is not found in application layout.", :red
    say "        Replace <html> with <html class=\"<%= polaris_html_classes %>\" style=\"<%= polaris_html_styles %>\"> in your custom layour."
    say "        Replace <body> with <body style=\"<%= polaris_body_styles %>\"> in your custom layour."
  end
else
  say "Default application.html.erb is missing!", :red
  say "        1. Add <%= stylesheet_link_tag \"polaris_view_components\" %> within the <head> tag in your custom layout."
  say "        2. Replace <html> with <html class=\"<%= polaris_html_classes %>\" style=\"<%= polaris_html_styles %>\"> in your custom layour."
  say "        3. Replace <body> with <body style=\"<%= polaris_body_styles %>\"> in your custom layour."
end

if IMPORTMAP_BINSTUB.exist?
  importmaps = File.read(IMPORTMAP_CONFIG_PATH)

  unless importmaps.include?("@rails/request.js")
    say "Pin @rails/request.js dependency"
    run "bin/importmap pin @rails/request.js --download"
  end

  say "Pin polaris_view_components"
  append_to_file IMPORTMAP_CONFIG_PATH do
    %(pin "polaris-view-components", to: "polaris_view_components.js"\n)
  end
else
  package_json = File.read(Rails.root.join("package.json"))

  unless package_json.include?("@rails/request.js")
    say "Add @rails/request.js dependency"
    run "yarn add @rails/request.js"
  end

  say "Add polaris-view-components package"
  run "yarn add polaris-view-components"
end

if STIMULUS_PATH.exist?
  say "Add Polaris Stimulus controllers"
  append_to_file STIMULUS_PATH do
    "\nimport { registerPolarisControllers } from \"polaris-view-components\"\nregisterPolarisControllers(Stimulus)\n"
  end
else
  say "Default Stimulus location is missing: app/javascript/controllers/index.js", :red
  say "        Add to your Stimulus index.js:"
  say "            import { registerPolarisControllers } from \"polaris-view-components\""
  say "            registerPolarisControllers(Stimulus)"
end
