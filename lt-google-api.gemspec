# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lt/google/api/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = 'lt-google-api'
  spec.version       = Lt::Google::Api::VERSION
  spec.authors       = ['Alexander Kuznetsov', 'Oksana Melnikova']
  spec.email         = %w(paranoic.san@gmail.com oksana.melnikova@gmail.com)

  spec.homepage    = 'https://github.com/learningtapestry/lt-google-api'
  spec.summary     = 'Provides the set of classes to simplify work with Google services'
  spec.description = ''
  spec.license     = 'Apache-2.0'

  spec.required_ruby_version = '>= 2.7'

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

  spec.add_dependency 'google-apis-drive_v3', '~> 0.46'
  spec.add_dependency 'googleauth', '~> 1.9'

  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'overcommit', '~> 0.57'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rubocop', '~> 1'
  spec.add_development_dependency 'steep', '~> 1.5.3'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
