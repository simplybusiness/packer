require 'fileutils'
require 'pathname'

require './spec/spec_helper.rb'

describe "Example Application" do
  before(:all) {
    packs_path = File.expand_path('../public/packs', File.dirname(__FILE__))
    FileUtils.rm_r(packs_path) if File.exists?(packs_path)
  }

  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should contain a generated app.js file" do
    get '/'
    exists = Pathname('.').join('public', 'packs', 'app.js').exist?
    expect(exists).to be true
  end
end
