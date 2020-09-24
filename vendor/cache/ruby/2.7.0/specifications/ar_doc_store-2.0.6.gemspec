# -*- encoding: utf-8 -*-
# stub: ar_doc_store 2.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "ar_doc_store".freeze
  s.version = "2.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Furber".freeze]
  s.date = "2018-11-21"
  s.description = "Provides an easy way to do something that is possible in Rails but still a bit close to the metal using store_accessor: create typecasted, persistent attributes that are not columns in the database but stored in the JSON \"data\" column. Also supports infinite nesting of embedded models.".freeze
  s.email = ["dfurber@gorges.us".freeze]
  s.homepage = "https://github.com/dfurber/ar_doc_store".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "A document storage gem meant for ActiveRecord PostgresQL JSON storage.".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 5.2"])
    s.add_runtime_dependency(%q<pg>.freeze, [">= 0"])
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 5.2"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
  end
end
