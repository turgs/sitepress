require "spec_helper"

RSpec.describe "Hotwire and Tailwind Integration" do
  describe "importmap configuration" do
    it "includes Hotwire dependencies" do
      dummy_app_path = File.join(__dir__, "../../dummy")
      importmap_path = File.join(dummy_app_path, "config/importmap.rb")
      
      expect(File.exist?(importmap_path)).to be true
      
      importmap_content = File.read(importmap_path)
      expect(importmap_content).to include('@hotwired/turbo-rails')
      expect(importmap_content).to include('@hotwired/stimulus')
      expect(importmap_content).to include('@hotwired/stimulus-loading')
    end
  end

  describe "Stimulus controllers" do
    it "has required controller files" do
      dummy_app_path = File.join(__dir__, "../../dummy")
      controllers_path = File.join(dummy_app_path, "app/assets/javascripts/controllers")
      
      expect(File.exist?(File.join(controllers_path, "index.js"))).to be true
      expect(File.exist?(File.join(controllers_path, "application.js"))).to be true
      expect(File.exist?(File.join(controllers_path, "hello_controller.js"))).to be true
      expect(File.exist?(File.join(controllers_path, "counter_controller.js"))).to be true
    end

    it "has correct controller structure" do
      dummy_app_path = File.join(__dir__, "../../dummy")
      hello_controller_path = File.join(dummy_app_path, "app/assets/javascripts/controllers/hello_controller.js")
      
      controller_content = File.read(hello_controller_path)
      expect(controller_content).to include('import { Controller } from "@hotwired/stimulus"')
      expect(controller_content).to include('data-controller="hello"')
    end
  end

  describe "application layout" do
    it "includes Tailwind CSS" do
      dummy_app_path = File.join(__dir__, "../../dummy")
      layout_path = File.join(dummy_app_path, "app/views/layouts/application.html.erb")
      
      layout_content = File.read(layout_path)
      expect(layout_content).to include('cdn.tailwindcss.com')
      expect(layout_content).to include('javascript_importmap_tags')
      expect(layout_content).to include('stylesheet_link_tag')
    end
  end

  describe "demo page" do
    it "exists and includes Hotwire demos" do
      dummy_app_path = File.join(__dir__, "../../dummy")
      demo_page_path = File.join(dummy_app_path, "app/content/pages/hotwire_demo.html.erb")
      
      expect(File.exist?(demo_page_path)).to be true
      
      demo_content = File.read(demo_page_path)
      expect(demo_content).to include('data-controller="hello"')
      expect(demo_content).to include('data-controller="counter"')
      expect(demo_content).to include('Tailwind')
      expect(demo_content).to include('Stimulus')
      expect(demo_content).to include('Turbo')
    end
  end
end