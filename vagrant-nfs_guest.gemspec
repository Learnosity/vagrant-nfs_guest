# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-nfs_guest/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-nfs_guest"
  spec.version       = VagrantPlugins::SyncedFolderNFSGuest::VERSION
  spec.authors       = ["Alan Garfield"]
  spec.email         = ["alan.garfield@learnosity.com"]
  spec.description   = %q{Adds support for guest nfs exporting of synced folders}
  spec.summary       = %q{Adds support for guest nfs exporting of synced folders}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
