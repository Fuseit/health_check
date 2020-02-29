lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'health_check'
  spec.version       = 1.0
  spec.authors       = ['Casper Coertze']
  spec.email         = ['casper.coertze@fuseuniversal.com']
  spec.summary       = %q{Rack middleware serving a health check page}
  spec.homepage      = 'https://github.com/Fuseit/health_check'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rack'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  spec.add_development_dependency 'rubocop-junit-formatter', '~> 0.1'
end
