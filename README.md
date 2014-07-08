# Vagrant-NFS_Guest

## What's New?

- Supports Vagrant 1.6! (For pre-1.5 vagrant support use the v0.0.4 release as Vagrant has incompatible changes)
- Handles actions ```up```, ```halt```, ```destroy```, ```suspend```, ```resume``` and ```package``` properly
- Uses retryable() for host to guest communications allow more fault tolerance
- Better error messages and handling
- Re-organisation of modules and class to better match Vagrant proper
- Simplified the plugin events binding
- Will install the NFS daemon on the guest if the guest capability is supported (Ubuntu only at this stage)

## Overview

Allows a guest VM to export synced folders via NFS and the host to mount them.

Basically it's just the usual NFS synced folders in Vagrant but the roles are reversed.

**WARNING** this has only been tested fully using an OSX host and a Ubuntu guest.
We're happy to receive pull-request to support alternatives hosts and guests. To implement this support is relatively trivial if you look in ./lib/hosts and ./lib/guests, and then just modify the "plugin.py" to include the new capabilities.

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
