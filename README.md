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

Then, assuming Packer is already installed, from the top level of this repo,
do this to build the AWS image:

    packer build -var-file=credentials.json example.json

This builds an image with the defualt role, which doesn't do much.

This example comes with an alternative role, `student`, which can be selected
by overriding the `puppet_role` user variable, like this:

    packer build -var-file=credentials.json -var puppet_role=student example.json
