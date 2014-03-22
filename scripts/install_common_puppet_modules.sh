#!/bin/sh

# Install some common Puppet modules.
MODULES="puppetlabs-git puppetlabs-vcsrepo"
for mod in $MODULES; do
  sudo puppet module install $mod
done
