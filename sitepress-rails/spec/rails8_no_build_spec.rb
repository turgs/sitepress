require "spec_helper"

describe "Rails 8 No-Build Configuration", type: :request do
  describe "Dependencies check" do
    it "uses propshaft instead of sprockets-rails" do
      gemspec = Gem::Specification.find_by_name("sitepress-rails")
      sprockets_dep = gemspec.dependencies.find { |dep| dep.name == "sprockets-rails" }
      propshaft_dep = gemspec.dependencies.find { |dep| dep.name == "propshaft" }
      
      expect(sprockets_dep).to be_nil
      expect(propshaft_dep).not_to be_nil
    end

    it "includes importmap-rails dependency" do
      gemspec = Gem::Specification.find_by_name("sitepress-rails")
      importmap_dep = gemspec.dependencies.find { |dep| dep.name == "importmap-rails" }
      
      expect(importmap_dep).not_to be_nil
    end
  end

  describe "Asset configuration" do
    it "loads propshaft" do
      expect(defined?(Propshaft)).to be_truthy
    end

    it "loads importmap-rails" do
      expect(defined?(Importmap)).to be_truthy
    end

    it "does not load sprockets" do
      expect(defined?(Sprockets::Rails)).to be_falsy
    end
  end

  describe "Database configuration" do
    it "uses sqlite as default database" do
      expect(Rails.application.config.database_configuration["test"]["adapter"]).to eq("sqlite3")
    end
  end

  describe "No build process required" do
    it "does not require node_modules directory" do
      expect(File.exist?(Rails.root.join("node_modules"))).to be_falsy
    end

    it "does not require package.json" do
      expect(File.exist?(Rails.root.join("package.json"))).to be_falsy
    end

    it "does not have build scripts" do
      expect(File.exist?(Rails.root.join("bin/build"))).to be_falsy
      expect(File.exist?(Rails.root.join("webpack.config.js"))).to be_falsy
    end
  end

  describe "Application structure" do
    it "has importmap configuration file" do
      expect(File.exist?(Rails.root.join("config/importmap.rb"))).to be_truthy
    end

    it "has application.js without sprockets directives" do
      app_js_path = Rails.root.join("app/assets/javascripts/application.js")
      expect(File.exist?(app_js_path)).to be_truthy
      
      content = File.read(app_js_path)
      expect(content).not_to include("//= require")
      expect(content).to include("Sitepress Rails 8 no-build application loaded")
    end

    it "does not have sprockets manifest file" do
      expect(File.exist?(Rails.root.join("app/assets/config/manifest.js"))).to be_falsy
    end

    it "does not have assets initializer" do
      expect(File.exist?(Rails.root.join("config/initializers/assets.rb"))).to be_falsy
    end
  end

  describe "Basic site functionality" do
    it "has sitepress_pages route defined" do
      # Test that sitepress_pages is defined in routes.rb
      routes_file = File.read(Rails.root.join("config/routes.rb"))
      expect(routes_file).to include("sitepress_pages")
    end
  end
end