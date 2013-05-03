shared_context "tmp path" do
  let(:gem_root_path) do
    File.expand_path(File.dirname(__FILE__)+"/../..")
  end
  let(:tmp_path) do
    "#{gem_root_path}/tmp"
  end
end