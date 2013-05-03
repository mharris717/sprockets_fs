require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SprocketsFs" do
  include_context "with setup dir"
  let(:dir) do
    SprocketsFS::SprocketsDir.new(:parent_dir => parent_dir)
  end
  def parent_file(path)
    File.read("#{parent_dir}/#{path}")
  end

  describe "Unit" do
    let(:file_hash) do
      {"main.js" => "var abc = 42;", "widgets/stuff.js" => "var widget = 'Green'"}
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

  describe "Coffee" do
    let(:file_hash) do
      {"double.js.coffee" => "double = (x) -> x * 2"}
    end

    it 'converts to js' do
      dir.read_file("/double.js").should == CoffeeScript.compile(file_hash["double.js.coffee"]).strip
    end
    it 'coffee read is raw' do
      dir.read_file("/double.js.coffee").should == file_hash["double.js.coffee"]
    end
    it 'js version is file' do
      dir.should be_file("/double.js")
    end

    it 'contents has js' do
      dir.contents("/").should include("double.js")
    end
  end

  describe "Write" do
    let(:file_hash) do
      {"zzz.js" => "abc = 42;"}
    end

    describe "raw" do
      before do
        dir.write_to "/abc.js","var abc = 42;"
      end

      it 'read back' do
        dir.read_file("/abc.js").strip.should == 'var abc = 42;'
      end
    end

    describe "coffee" do
      before do
        dir.write_to "/double.js.coffee","double = (x) -> x * 2"
      end

      it 'read coffee' do
        dir.read_file("/double.js.coffee").strip.should == "double = (x) -> x * 2"
      end

      it 'read js' do
        dir.read_file("/double.js").should =~ /double = function/
      end

      it 'write to js fails' do
        dir.can_write?("/double.js").should_not be
      end
    end
  end

  describe "erb" do
    let(:file_hash) do
      {"index.html.erb" => "<% if true %> abc <% end %>"}
    end

    it 'read parsed' do
      dir.read_file("/index.html").strip.should == "abc"
    end
  end

  
end



