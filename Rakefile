# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "sprockets_fs"
  gem.homepage = "http://github.com/mharris717/sprockets_fs"
  gem.license = "MIT"
  gem.summary = %Q{sprockets_fs}
  gem.description = %Q{sprockets_fs}
  gem.email = "mharris717@gmail.com"
  gem.authors = ["Mike Harris"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sprockets_fs #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :mount do
  load File.dirname(__FILE__) + "/lib/sprockets_fs.rb"

  gem_name = "sprockets_fs"
  parent_dir = "/code/orig/sprockets_fs/spec/data/parent"
  mount_dir = "/tmp/mount_sp"

  exec "ruby /code/orig/#{gem_name}/bin/#{gem_name} #{parent_dir} #{mount_dir}"
end