def setup_dir(files,tmp_path)
  path = "#{tmp_path}/test_dir_#{rand(100000000000000)}"
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
    setup_dir file_hash, tmp_path
  end
  before do
    parent_dir
  end
end