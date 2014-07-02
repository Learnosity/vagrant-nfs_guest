# Vagrant-NFS_Guest

## What's New?

- Supports Vagrant 1.6!
- Handles actions ```up```, ```halt```, ```destroy```, ```suspend```, ```resume``` and ```package``` properly
- Uses retryable() for host to guest communications allow more fault tolerance
- Better error messages and handling
- Re-organisation of modules and class to better match Vagrant proper
- Simplified the plugin events binding

## Overview

Allows a guest VM to export synced folders via NFS and the host to mount them.

Basically it's just the usual NFS synced folders in Vagrant but the roles are reversed.

## Installation

    vagrant plugin install vagrant-nfs_guest

## Install from sources

    git clone https://github.com/Learnosity/vagrant-nfs_guest.git
    cd vagrant-nfs_guest
    bundle install
    bundle exec rake build
    vagrant plugin install pkg/vagrant-nfs_guest-VERSION.gem

## Usage

To enable for example put similar in the Vagrantfile:

    config.vm.synced_folder 'srv', '/srv', type: 'nfs_guest'

## Building

We use 'chruby' to allow a virtual ruby environment for developement. The 'bundle' gem is needed to build and run

    git clone https://github.com/Learnosity/vagrant-nfs_guest.git
    cd vagrant-nfs_guest
    bundle install
    bundle exec vagrant
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
