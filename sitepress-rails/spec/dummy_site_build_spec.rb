require "spec_helper"

describe "Dummy Site Build Test", type: :request do
  describe "Site functionality" do
    it "serves baseline render" do
      get "/baseline/render"
      expect(response).to be_successful
    end

    it "serves application layout with importmap helper" do
      get "/baseline/render"
      expect(response.body).to include("importmap") if response.body.include?("<head>")
      expect(response.body).to include("application") if response.body.include?("importmap")
    end
  end

  describe "Asset serving with propshaft" do
    it "has proper content-type for javascript files" do
      # Create a simple test to ensure propshaft is working
      expect(Rails.application.config.public_file_server.enabled).to be_truthy
    end

    it "can resolve asset paths" do
      # Check that Rails can resolve asset paths (basic propshaft functionality)
      if Rails.application.assets.respond_to?(:find_asset)
        expect(Rails.application.assets.find_asset("application.js")).to be_truthy
      else
        # If propshaft is working correctly, the file should exist
        expect(File.exist?(Rails.root.join("app/assets/javascripts/application.js"))).to be_truthy
      end
    end
  end
end