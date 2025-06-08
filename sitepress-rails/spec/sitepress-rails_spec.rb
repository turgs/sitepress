require "spec_helper"
require "sitepress-rails"

describe "Sitepress.configuration" do
  let(:app) { Rails.application }
  subject { Sitepress.configuration }

  it "has Rails.application as parent engine" do
    expect(subject.parent_engine).to eql(app)
  end
end

describe "Sitepress Rails gem dependencies" do
  let(:gemspec_path) { File.join(__dir__, "../sitepress-rails.gemspec") }
  let(:gemspec_content) { File.read(gemspec_path) }

  it "includes propshaft dependency" do
    expect(gemspec_content).to include('propshaft')
  end

  it "includes importmap-rails dependency" do
    expect(gemspec_content).to include('importmap-rails')
  end

  it "includes stimulus-rails dependency" do
    expect(gemspec_content).to include('stimulus-rails')
  end

  it "includes turbo-rails dependency" do
    expect(gemspec_content).to include('turbo-rails')
  end
end
