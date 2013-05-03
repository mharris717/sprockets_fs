require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Rails' do
  include_context "fork"

  let(:cmds) do
    file = File.expand_path(File.dirname(__FILE__)+"/../bin/sprockets_fs")

    "cd #{app_path} && ruby #{file}"
  end

  let(:app_path) do
    File.expand_path(File.dirname(__FILE__)+"/../vol/mount_app")
  end
  let(:mount_dir) do
    "#{app_path}/asset_fs"
  end

  def wait_until_mounted
    (0...150).each do 
      return if Dir["#{app_path}/asset_fs/*"].size > 0
      sleep(0.1)
    end
    raise 'not mounted'
  end

  before do
    wait_until_mounted
  end

  it 'smoke' do
    puts "rails smoke"
    #sleep(100000)
    2.should == 2
  end

  it 'read root' do
    Dir["#{mount_dir}/*"].sort.should == %w(images javascripts stylesheets).map { |x| "#{mount_dir}/#{x}" }
  end

  it 'read js folder' do
    exp = %w(application.js widgets.js widgets.js.coffee main.js).map { |x| "#{mount_dir}/javascripts/#{x}" }.sort
    Dir["#{mount_dir}/javascripts/*"].sort.should == exp
  end

  it 'read coffee' do
    File.read("#{mount_dir}/javascripts/widgets.js.coffee").strip.should == "double = (x) -> x * 2"
  end

  it 'read js' do
    File.read("#{mount_dir}/javascripts/widgets.js").strip.size.should > 0
    #File.read("/tmp/mount_rails/javascripts/widgets.js").strip.should =~ /double = function/
  end

  it 'read js basic' do
    File.read("#{mount_dir}/javascripts/main.js").strip.should == "var abc = 42;"
    #File.read("/tmp/mount_rails/javascripts/widgets.js").strip.should =~ /double = function/
  end
end