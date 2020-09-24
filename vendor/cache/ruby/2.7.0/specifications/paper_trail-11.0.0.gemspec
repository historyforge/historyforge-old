# -*- encoding: utf-8 -*-
# stub: paper_trail 11.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "paper_trail".freeze
  s.version = "11.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andy Stewart".freeze, "Ben Atkins".freeze, "Jared Beck".freeze]
  s.date = "2020-08-24"
  s.description = "Track changes to your models, for auditing or versioning. See how a model looked\nat any stage in its lifecycle, revert it to any version, or restore it after it\nhas been destroyed.\n".freeze
  s.email = "jared@jaredbeck.com".freeze
  s.homepage = "https://github.com/paper-trail-gem/paper_trail".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4.0".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Track changes to your models.".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 5.2"])
    s.add_runtime_dependency(%q<request_store>.freeze, ["~> 1.1"])
    s.add_development_dependency(%q<appraisal>.freeze, ["~> 2.2"])
    s.add_development_dependency(%q<byebug>.freeze, ["~> 11.0"])
    s.add_development_dependency(%q<ffaker>.freeze, ["~> 2.11"])
    s.add_development_dependency(%q<generator_spec>.freeze, ["~> 0.9.4"])
    s.add_development_dependency(%q<memory_profiler>.freeze, ["~> 0.9.14"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 4.0"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.89.1"])
    s.add_development_dependency(%q<rubocop-performance>.freeze, ["~> 1.7.1"])
    s.add_development_dependency(%q<rubocop-rspec>.freeze, ["~> 1.42.0"])
    s.add_development_dependency(%q<mysql2>.freeze, ["~> 0.5"])
    s.add_development_dependency(%q<pg>.freeze, [">= 0.18", "< 2.0"])
    s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 5.2"])
    s.add_dependency(%q<request_store>.freeze, ["~> 1.1"])
    s.add_dependency(%q<appraisal>.freeze, ["~> 2.2"])
    s.add_dependency(%q<byebug>.freeze, ["~> 11.0"])
    s.add_dependency(%q<ffaker>.freeze, ["~> 2.11"])
    s.add_dependency(%q<generator_spec>.freeze, ["~> 0.9.4"])
    s.add_dependency(%q<memory_profiler>.freeze, ["~> 0.9.14"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 4.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.89.1"])
    s.add_dependency(%q<rubocop-performance>.freeze, ["~> 1.7.1"])
    s.add_dependency(%q<rubocop-rspec>.freeze, ["~> 1.42.0"])
    s.add_dependency(%q<mysql2>.freeze, ["~> 0.5"])
    s.add_dependency(%q<pg>.freeze, [">= 0.18", "< 2.0"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
  end
end
