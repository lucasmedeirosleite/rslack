# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rslack/version'

Gem::Specification.new do |spec|
  spec.name          = 'RSlack'
  spec.version       = RSlack::VERSION
  spec.authors       = ['Lucas Medeiros Leite']
  spec.email         = ['lucastoc@gmail.com']

  spec.summary       = %q{ A Ruby master slack bot. }
  spec.description   = %q{ A Ruby master slack bot. }
  spec.homepage      = 'https://github.com/lucasmedeirosleite/rslack'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client', '1.8.0'
  spec.add_dependency 'faye', '1.1.2'
  spec.add_dependency 'rdoc', '4.2.2'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry-byebug'
end
