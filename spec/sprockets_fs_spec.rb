require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SprocketsFs" do

  describe "Unit" do
    let(:dir) do
      SprocketsFS::SprocketsDir.new(:parent_dir => parent_dir)
    end
    let(:file_hash) do
      {"main.js" => "var abc = 42;", "widgets/stuff.js" => "var widget = 'Green'"}
    end
    let(:parent_dir) do
      #File.dirname(__FILE__) + "/data/parent"
      setup_dir file_hash
    end

    def parent_file(path)
      File.read("#{parent_dir}/#{path}")
    end

    it 'read file' do
      dir.read_file("/main.js").should == parent_file("main.js")
    end
    it 'has files' do
      dir.files.size.should == file_hash.size
    end
    it 'has dirs' do
      dir.dirs.should == ["widgets"]
    end

    it 'contents has dirs' do
      dir.contents("/").sort.should == ["main.js","widgets"]
    end
    it 'sub contents' do
      dir.contents("/widgets").should == ["stuff.js"]
    end
  end

  describe "coffee" do
    let(:dir) do
      SprocketsFS::SprocketsDir.new(:parent_dir => parent_dir)
    end
    let(:file_hash) do
      {"double.js.coffee" => "double = (x) -> x * 2"}
    end
    let(:parent_dir) do
      setup_dir file_hash
    end

    it 'converts to js' do
      dir.read_file("/double.js").should == CoffeeScript.compile(file_hash["double.js.coffee"]).strip
    end
    it 'js version is file' do
      dir.should be_file("/double.js")
    end
  end


  describe "Integration" do
    it "smoke" do
      2.should == 2
    end

    it 'read' do
      File.read("/tmp/test_sp/main.js").should == "var abc = 42;"
    end
  end
end
