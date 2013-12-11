# Vagrant::NfsGuest

Allows a guest VM to export synced folders via NFS and the host to mount them.

Basically it's just the usual NFS synced folders in Vagrant but the roles are reversed.

## Installation

Add this line to your application's Gemfile:

    gem 'vagrant-nfs_guest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vagrant-nfs_guest

## Usage

To enable for example:

```config.vm.synced_folder 'srv', '/srv', type: 'nfs_guest'```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
