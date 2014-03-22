#!/bin/sh
# Install the Puppet Release package, which adds a new source of packages to Apt.
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb

# Update Apt's source list to pick up the latest & greatest Puppet packages.
sudo apt-get update -y

# Install Puppet.
sudo apt-get install -y puppet-common
