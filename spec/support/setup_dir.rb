def setup_dir(files)
  FileUtils.mkdir("/tmp/test_dirs") unless FileTest.exist?("/tmp/test_dirs")
  path = "/tmp/test_dirs/test_dir_#{rand(100000000000000)}"
  FileUtils.mkdir(path)
  files.each do |f,body|
    dir = "#{path}/#{File.dirname(f)}"
    FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)

    File.create "#{path}/#{f}",body
  end
  path
end

shared_context "with setup dir" do
  let(:parent_dir) do
    setup_dir file_hash
  end
  before do
    parent_dir
  end
end