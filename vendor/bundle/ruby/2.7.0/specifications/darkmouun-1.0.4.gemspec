# -*- encoding: utf-8 -*-
# stub: darkmouun 1.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "darkmouun".freeze
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/akinori-ichigo/darkmouun", "homepage_uri" => "https://github.com/akinori-ichigo/darkmouun", "source_code_uri" => "https://github.com/akinori-ichigo/darkmouun" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Akinori Ichigo".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-09-27"
  s.description = "Darkmouun converts Markdown document to HTML by processing of pre, Mustache template, Kramdown, and post.".freeze
  s.email = ["akinori.ichigo@gmail.com".freeze]
  s.homepage = "https://github.com/akinori-ichigo/darkmouun".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.1.4".freeze
  s.summary = "The Processting tool from Markdown to HTML".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_runtime_dependency(%q<mustache>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<kramdown>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<htmlbeautifier>.freeze, [">= 0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<mustache>.freeze, [">= 0"])
    s.add_dependency(%q<kramdown>.freeze, [">= 0"])
    s.add_dependency(%q<htmlbeautifier>.freeze, [">= 0"])
  end
end
