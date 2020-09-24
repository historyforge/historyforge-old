# -*- encoding: utf-8 -*-
# stub: spawnling 2.1.6 ruby lib

Gem::Specification.new do |s|
  s.name = "spawnling".freeze
  s.version = "2.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tom Anderson".freeze, "Michael Noack".freeze]
  s.date = "2015-05-14"
  s.description = "This plugin provides a 'Spawnling' class to easily fork OR\nthread long-running sections of code so that your application can return\nresults to your users more quickly.  This plugin works by creating new database\nconnections in ActiveRecord::Base for the spawned block.\n\nThe plugin also patches ActiveRecord::Base to handle some known bugs when using\nthreads (see lib/patches.rb).".freeze
  s.email = ["tom@squeat.com".freeze, "michael+spawnling@noack.com.au".freeze]
  s.homepage = "http://github.com/tra/spawnling".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Easily fork OR thread long-running sections of code in Ruby".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 2.0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_development_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
    s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
    s.add_development_dependency(%q<rails>.freeze, [">= 0"])
    s.add_development_dependency(%q<activerecord-nulldb-adapter>.freeze, [">= 0"])
    s.add_development_dependency(%q<dalli>.freeze, [">= 0"])
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0"])
    s.add_dependency(%q<rails>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord-nulldb-adapter>.freeze, [">= 0"])
    s.add_dependency(%q<dalli>.freeze, [">= 0"])
  end
end
