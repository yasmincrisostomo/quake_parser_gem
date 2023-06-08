# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'quake_parser'
  spec.version       = '0.1.4'
  spec.authors       = ['']
  spec.email         = ['crisostomyasmin@gmail.com']
  spec.summary       = 'A gem for parsing Quake log files.'
  spec.description   = 'A gem that provides functionality to parse and analyze Quake log files.'
  spec.homepage      = 'https://github.com/yasmincrisostomo/quake_parser'
  spec.license       = 'MIT'

  spec.add_dependency 'json', '~> 2.5'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.files         = Dir["lib/**/*.rb"]
end
