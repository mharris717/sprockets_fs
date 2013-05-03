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
    a = Dir["#{mount_dir}/*"].map { |x| x.gsub("/mnt/hgfs/Code/orig/sprockets_fs/vol/mount_app/asset_fs/","") }
    #raise a.inspect
  end

  it 'read root' do
    exp = ["application.js", "main.js", "widgets.js.coffee", "widgets.js", "application.css", "widgets.css.scss"]
    exp += %w(foo.js foo.js.erb)
    exp += ["jquery-ui.js", "jquery-ui.min.js", "jquery.js", "jquery.min.js", "jquery.min.map", "jquery_ujs.js", "coffee-script.js.erb", "coffee-script.js"]
    Dir["#{mount_dir}/*"].sort.should == exp.sort.map { |x| "#{mount_dir}/#{x}" }
  end

  it 'read js folder' do
    exp = %w(application.js widgets.js widgets.js.coffee main.js)
    exp += %w(foo.js foo.js.erb)
    exp += %w(coffee-script.js coffee-script.js.erb jquery-ui.js jquery-ui.min.js jquery.js jquery.min.js jquery_ujs.js)
    exp = exp.map { |x| "#{mount_dir}/#{x}" }.sort
    Dir["#{mount_dir}/*"].select { |x| x =~ /\.js/ }.sort.should == exp
  end

  it 'read coffee' do
    File.read("#{mount_dir}/widgets.js.coffee").strip.should == "double = (x) -> x * 2"
  end

  it 'read js' do
    File.read("#{mount_dir}/widgets.js").strip.size.should > 0
    #File.read("/tmp/mount_rails/javascripts/widgets.js").strip.should =~ /double = function/
  end

  it 'read js basic' do
    File.read("#{mount_dir}/main.js").strip.should == "var abc = 42;"
    #File.read("/tmp/mount_rails/javascripts/widgets.js").strip.should =~ /double = function/
  end

  describe 'erb' do

    it 'read js erb' do
      File.read("#{mount_dir}/foo.js.erb").should == File.read("vol/mount_app/app/assets/javascripts/foo.js.erb")
    end

    it 'read js erb as js' do
      File.read("#{mount_dir}/foo.js").strip.should == "var abc = 42;"
    end

    it 'write to js erb' do
      lambda do
        File.create "#{mount_dir}/foo.js.erb",File.read("vol/mount_app/app/assets/javascripts/foo.js.erb")
      end.should_not raise_error
      FileTest.should_not be_exist("vol/mount_app/app/assets/images/foo.js.erb")
      FileTest.should_not be_exist("vol/mount_app/app/assets/images/foo.js")
    end

    it 'write to js erb as js' do
      lambda do
        File.create "#{mount_dir}/foo.js","123"
      end.should raise_error
    end
  end


end