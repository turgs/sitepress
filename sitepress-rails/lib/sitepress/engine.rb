require "rails/engine"
require "sitepress/routing_mapper"

module Sitepress
  class Engine < ::Rails::Engine
    # Set the root of the engine to the gems rails directory.
    config.root = File.expand_path("../../rails", __dir__)

    # Set the path for the site configuration file.
    paths.add "config/site.rb", with: [
      File.expand_path("./config/site.rb"), # When Sitepress is launched via `sitepress server`.
      "config/site.rb"                      # When Sitepress is launched embedded in Rails project.
    ]

    # Load the `config/site.rb` file so users can configure Sitepress.
    initializer :load_sitepress_file, before: :set_sitepress_paths do
      site_file = paths["config/site.rb"].existent.first
      load site_file if site_file
    end

    # Set the path for the site configuration file.
    paths.add "app/markdown", with: [
      File.expand_path("./markdown"),     # When Sitepress is launched via `sitepress server`.
      "app/markdown"                      # When Sitepress is launched embedded in Rails project.
    ], autoload: true

    # Load paths from `Sitepress#site` into rails so it can render views, helpers, etc. properly.
    initializer :set_sitepress_paths, before: :set_autoload_paths do |app|
      app.paths["app/helpers"].push site.helpers_path.expand_path
      app.paths["app/assets"].push site.assets_path.expand_path
      app.paths["app/views"].push site.root_path.expand_path
      app.paths["app/views"].push site.pages_path.expand_path
      app.paths["app/models"].push site.models_path.expand_path
    end

    # Set for view_components to load at ./components
    initializer :add_components_autoload_path, before: :set_autoload_paths do |app|
      components_path = File.expand_path("./components")
      app.config.autoload_paths.push(components_path) unless app.config.autoload_paths.include?(components_path)
    end

    # Configure Sitepress with Rails settings.
    initializer :configure_sitepress do |app|
      sitepress_configuration.parent_engine = app
      # Reloads entire site between requests for development environments.
      sitepress_configuration.cache_resources = if app.config.respond_to? :enable_reloading?
        # Rails 7.1 changed the name of this setting to enable_reloading, so check if that exist and use it.
        app.config.enable_reloading?
      else
        # Rails 7.0.x and lower all use this method to check if reloading is enabled.
        app.config.cache_classes
      end

      config.to_prepare do
        Sitepress::Path.handler_extensions = ActionView::Template::Handlers.extensions
      end
    end

    private

    def sitepress_configuration
      Sitepress.configuration
    end

    def site
      sitepress_configuration.site
    end
  end
end
