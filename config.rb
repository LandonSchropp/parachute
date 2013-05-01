require "sprockets/ember_handlebars_template"

# remove the layout from the application
page "/*", :layout => false

# set the directories
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Automatically reload the page when the relevant files change
activate :livereload

# Set up deployments to GitHub pages
activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = "master"
end

# build configuration
configure :build do

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :cache_buster

  # Compress PNGs after build
  require "middleman-smusher"
  activate :smusher

  # make the asset paths relative
  activate :relative_assets
end