# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sprockets_fs"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Harris"]
  s.date = "2013-05-02"
  s.description = "sprockets_fs"
  s.email = "mharris717@gmail.com"
  s.executables = ["sprockets_fs"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/sprockets_fs",
    "lib/sprockets_fs.rb",
    "lib/sprockets_fs/log.rb",
    "lib/sprockets_fs/rails.rb",
    "spec/data/parent/double.js.coffee",
    "spec/data/parent/main.js",
    "spec/spec_helper.rb",
    "spec/sprockets_fs_spec.rb",
    "spec/support/setup_dir.rb",
    "spec/support/spec_forks.rb",
    "sprockets_fs.gemspec",
    "vol/env_explore.rb",
    "vol/mongo_test.rb",
    "vol/mount_app/.gitignore",
    "vol/mount_app/Gemfile",
    "vol/mount_app/Gemfile.lock",
    "vol/mount_app/README.rdoc",
    "vol/mount_app/Rakefile",
    "vol/mount_app/app/assets/images/rails.png",
    "vol/mount_app/app/assets/javascripts/application.js",
    "vol/mount_app/app/assets/javascripts/main.js",
    "vol/mount_app/app/assets/javascripts/widgets.js.coffee",
    "vol/mount_app/app/assets/stylesheets/application.css",
    "vol/mount_app/app/assets/stylesheets/widgets.css.scss",
    "vol/mount_app/app/controllers/application_controller.rb",
    "vol/mount_app/app/controllers/widgets_controller.rb",
    "vol/mount_app/app/helpers/application_helper.rb",
    "vol/mount_app/app/helpers/widgets_helper.rb",
    "vol/mount_app/app/mailers/.gitkeep",
    "vol/mount_app/app/models/.gitkeep",
    "vol/mount_app/app/models/widget.rb",
    "vol/mount_app/app/views/layouts/application.html.erb",
    "vol/mount_app/config.ru",
    "vol/mount_app/config/application.rb",
    "vol/mount_app/config/boot.rb",
    "vol/mount_app/config/database.yml",
    "vol/mount_app/config/environment.rb",
    "vol/mount_app/config/environments/development.rb",
    "vol/mount_app/config/environments/production.rb",
    "vol/mount_app/config/environments/test.rb",
    "vol/mount_app/config/initializers/backtrace_silencers.rb",
    "vol/mount_app/config/initializers/inflections.rb",
    "vol/mount_app/config/initializers/mime_types.rb",
    "vol/mount_app/config/initializers/secret_token.rb",
    "vol/mount_app/config/initializers/session_store.rb",
    "vol/mount_app/config/initializers/wrap_parameters.rb",
    "vol/mount_app/config/locales/en.yml",
    "vol/mount_app/config/routes.rb",
    "vol/mount_app/db/migrate/20130429140835_create_widgets.rb",
    "vol/mount_app/db/seeds.rb",
    "vol/mount_app/lib/assets/.gitkeep",
    "vol/mount_app/lib/tasks/.gitkeep",
    "vol/mount_app/log/.gitkeep",
    "vol/mount_app/public/404.html",
    "vol/mount_app/public/422.html",
    "vol/mount_app/public/500.html",
    "vol/mount_app/public/favicon.ico",
    "vol/mount_app/public/index.html",
    "vol/mount_app/public/robots.txt",
    "vol/mount_app/script/rails",
    "vol/mount_app/test/fixtures/.gitkeep",
    "vol/mount_app/test/fixtures/widgets.yml",
    "vol/mount_app/test/functional/.gitkeep",
    "vol/mount_app/test/functional/widgets_controller_test.rb",
    "vol/mount_app/test/integration/.gitkeep",
    "vol/mount_app/test/performance/browsing_test.rb",
    "vol/mount_app/test/test_helper.rb",
    "vol/mount_app/test/unit/.gitkeep",
    "vol/mount_app/test/unit/helpers/widgets_helper_test.rb",
    "vol/mount_app/test/unit/widget_test.rb",
    "vol/mount_app/traces.txt",
    "vol/mount_app/vendor/assets/javascripts/.gitkeep",
    "vol/mount_app/vendor/assets/stylesheets/.gitkeep",
    "vol/mount_app/vendor/plugins/.gitkeep",
    "vol/mount_app_runner.rb",
    "vol/mount_rails.rb"
  ]
  s.homepage = "http://github.com/mharris717/sprockets_fs"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "sprockets_fs"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mharris_ext>, [">= 0"])
      s.add_runtime_dependency(%q<lre>, [">= 0"])
      s.add_runtime_dependency(%q<guard>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<rfusefs>, [">= 0"])
      s.add_runtime_dependency(%q<coffee-script>, [">= 0"])
      s.add_runtime_dependency(%q<therubyracer>, [">= 0"])
      s.add_runtime_dependency(%q<sprockets>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
    else
      s.add_dependency(%q<mharris_ext>, [">= 0"])
      s.add_dependency(%q<lre>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<rfusefs>, [">= 0"])
      s.add_dependency(%q<coffee-script>, [">= 0"])
      s.add_dependency(%q<therubyracer>, [">= 0"])
      s.add_dependency(%q<sprockets>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    end
  else
    s.add_dependency(%q<mharris_ext>, [">= 0"])
    s.add_dependency(%q<lre>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<rfusefs>, [">= 0"])
    s.add_dependency(%q<coffee-script>, [">= 0"])
    s.add_dependency(%q<therubyracer>, [">= 0"])
    s.add_dependency(%q<sprockets>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
  end
end

