require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Integration" do
  include_context "tmp path"
  include_context "with setup dir"
  include_context "fork"

  let(:file_hash) do
    {"main.js" => "var abc = 42;", "widgets/stuff.js" => "var widget = 'Green'"}
  end

  let(:mount_dir) do
    res = "#{tmp_path}/mounted_#{rand(100000000000000)}"
    FileUtils.mkdir res
    res
  end

  let(:cmds) do
    dir = File.expand_path(File.dirname(__FILE__)+"/..")
    "ruby #{dir}/bin/sprockets_fs -p #{parent_dir} -m #{mount_dir}"
  end

  def wait_until_mounted
    (0...100).each do 
      return if Dir["#{mount_dir}/*"].size > 0
      sleep(0.03)
    end
    raise 'not mounted'
  end

  before do
    wait_until_mounted
  end

  it "smoke" do
    2.should == 2
  end

  it 'read' do
    File.read("#{mount_dir}/main.js").should == "var abc = 42;"
  end
end