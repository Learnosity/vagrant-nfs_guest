# Vagrant-NFS_Guest

## What's New?

- NEW: moved to version v1.0.0 as it's no longer a "beta" plugin, it's been well used and tested. So figured now is a good time.
- NEW: `disabled` flag on shares now are properly respected
- UPDATED: share directories on guest are no longer recursively `chown`.
- NEW: Added VMware Fusion provider support.
- Added untested support for Docker providers (Please raise any issues if they don't work!).
- Added Parallels provider support
- Redhat/CentOS guest support added.
- Now properly handles force halts.
- FIXED: suspend and resume with 'up' instead of 'resume' fixed.
- Supports Vagrant > 1.6.
- Handles actions ```up```, ```halt```, ```destroy```, ```suspend```, ```resume``` and ```package``` properly.
- Uses retryable() for host to guest communications allow more fault tolerance.
- Better error messages and handling.
- Re-organisation of modules and class to better match Vagrant proper.
- Simplified the plugin events binding.
- Will install the NFS daemon on the guest if the guest capability is supported (Ubuntu and Debian only at this stage).
- Supports BSD/OSX, and Linux based Hosts that support NFS mounting.

## Overview

Allows a guest VM to export synced folders via NFS and the host to mount them.

Basically it's just the usual NFS synced folders in Vagrant but the roles are reversed.

Guest VMs we've tested include:
- Ubuntu (precise, trusty)
- CentOS (6.5, 6.6, 7)
- Debian (wheezy)
- other Linux based guests may work fine with the generic Linux support. But no guarantee

Hosts we've tested include:
- OSX (Mavericks, Yosemite, El Capitan, Siera)
- Ubuntu (precise, trusty)
- CentOS (6, 7)
- other Linux based OSs should work fine, but will need testing, again no guarantee

We're happy to receive pull-request to support alternatives hosts and guests. To implement this support it's relatively trivial if you look in ./lib/hosts and ./lib/guests.

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

You can test your handy work using the ```example_box``` by doing the following:

    cd ./example_box/
    bundle exec vagrant up

You can ssh into the test VM using:

    bundle exec vagrant ssh

... and you can clean up with:

    bundle exec vagrant destroy

    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
