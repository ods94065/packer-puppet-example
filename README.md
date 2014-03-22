## Packer with Puppet Example

This expands on the basic Packer tutorial by showing how to:

   - Install Puppet modules for use in the puppet run
   - Supplement those Puppet modules with your own
   - Set up a basic Hiera configuration for your classes
   - Select different "roles" which define different sets of Puppet classes
     to include

## Running Packer

This example builds and uploads AWS images, which requires AWS credentials. To
configure this, I recommend you create (but not check in) a `credentials.json`
file containing your AWS credentials. It should look like this:

    {
        "aws_access_key": "YOUR ACCESS KEY GOES HERE",
        "aws_secret_key": "YOUR SECRET KEY GOES HERE"
    }

The Packer specs and Puppet manifests for configuring the images are built by
Rake. You can run `rake -T` to find out which targets are available; the
Packer targets are under `rake packs:*`. To build all of the images, do this:

    rake packs:all:build

## Configuring Nodes

Packer can easily generate multiple different images with the same configuration,
but it is not so handy when it comes to generating different kinds of images,
which may correspond to different machine "roles".

Inspired by the example provided by[James Carr's blog post](http://blog.james-carr.org/2013/07/24/immutable-servers-with-packer-and-puppet/),
we provide a mechanism to specify different kinds of "nodes", which differ
only in their Puppet node configuration. The configuration of these different
image kinds is managed by `nodes.yaml`.

To define a new kind of node, edit `nodes.yaml` and add your node name as a new
key at the top level. The `classes` list underneath it is a list of Puppet classes
to be included for the specified node. Rake will generate all the necessary tasks
to manage this kind of node based on the contents of `nodes.yaml`.
