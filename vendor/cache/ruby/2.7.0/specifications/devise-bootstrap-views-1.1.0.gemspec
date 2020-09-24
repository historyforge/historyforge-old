# -*- encoding: utf-8 -*-
# stub: devise-bootstrap-views 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "devise-bootstrap-views".freeze
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Yinghai Zhao".freeze]
  s.date = "2018-08-20"
  s.description = "Bootstrap views for Devise with I18n support.".freeze
  s.email = ["zyinghai@gmail.com".freeze]
  s.homepage = "https://github.com/hisea/devise-bootstrap-views".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Bootstrap views for Devise.".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.6"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 11.0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rake>.freeze, ["~> 11.0"])
  end
end
