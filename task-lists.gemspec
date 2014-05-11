# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'task_list/version'

Gem::Specification.new do |gem|
  gem.name          = "task-lists"
  gem.version       = TaskList::VERSION
  gem.authors       = ["Matt Todd"]
  gem.email         = ["matt@github.com"]
  gem.description   = %q{GitHub-flavored-Markdown TaskList components}
  gem.summary       = %q{GitHub-flavored-Markdown TaskList components}

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "html-pipeline"

  gem.add_development_dependency "github-markdown"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "coffee-script"
  gem.add_development_dependency "json"
  gem.add_development_dependency "rack"
  gem.add_development_dependency "sprockets"
  gem.add_development_dependency "minitest", "~> 5.3.2"
end
