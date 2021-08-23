source 'https://rubygems.org'

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
    gem "vagrant", :git => "https://github.com/mitchellh/vagrant.git", :tag => "v2.2.18"
    gem "rake"
end

group :plugins do
  gem "vagrant-nfs_guest", path: "."
end
