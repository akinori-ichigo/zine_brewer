require_relative 'lib/zine_brewer/version'

Gem::Specification.new do |spec|
  spec.name          = "zine_brewer"
  spec.version       = ZineBrewer::VERSION
  spec.authors       = ["Akinori Ichigo"]
  spec.email         = ["akinori.ichigo@gmail.com"]

  spec.summary       = %q{Kramdown to HTML converter for a web media}
  spec.homepage      = "https://github.com/akinori-ichigo/zine_brewer"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/akinori-ichigo/zine_brewer"
  spec.metadata["changelog_uri"] = "https://github.com/akinori-ichigo/zine_brewer"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "mustache"
  spec.add_runtime_dependency "darkmouun"
  spec.add_runtime_dependency "rchardet"
end
