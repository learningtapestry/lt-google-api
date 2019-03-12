# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lt/google/api/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = 'lt-google-api'
  spec.version       = Lt::Google::Api::VERSION
  spec.authors       = ['Alexander Kuznetsov']
  spec.email         = %w(alexander@learningtapeestry.com paranoic.san@gmail.com)

  spec.homepage    = 'https://github.com/learningtapestry/lt-google-api'
  spec.summary     = 'Provides the set of classes to simplify work with Google services'
  spec.description = ''
  spec.license     = 'Apache-2.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'google-api-client'
  spec.add_dependency 'googleauth'

  spec.add_development_dependency 'brakeman'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'overcommit', '~> 0.46'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
end
