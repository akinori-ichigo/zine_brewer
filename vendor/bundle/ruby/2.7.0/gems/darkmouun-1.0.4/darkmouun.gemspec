require_relative 'lib/darkmouun/version'

Gem::Specification.new do |spec|
  spec.name          = "darkmouun"
  spec.version       = Darkmouun::VERSION
  spec.authors       = ["Akinori Ichigo"]
  spec.email         = ["akinori.ichigo@gmail.com"]

  spec.summary       = %q{The Processting tool from Markdown to HTML}
  spec.description   = %q{Darkmouun converts Markdown document to HTML by processing of pre, Mustache template, Kramdown, and post.}
  spec.homepage      = "https://github.com/akinori-ichigo/darkmouun"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/akinori-ichigo/darkmouun"
  spec.metadata["changelog_uri"] = "https://github.com/akinori-ichigo/darkmouun"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "mustache"
  spec.add_runtime_dependency "kramdown"
  spec.add_runtime_dependency "htmlbeautifier"
end
