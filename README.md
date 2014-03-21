## Packer with Puppet Example

This expands on the basic Packer tutorial by showing how to:

   - Install Puppet modules for use in the puppet run
   - Supplement those Puppet modules with your own
   - Set up a basic Hiera configuration for your classes

## Configuration

This example builds and uploads AWS images. To access AWS, you will need to
create a `variables.json` file containing your AWS credentials. It should look
like this:

    {
        "aws_access_key": "YOUR ACCESS KEY GOES HERE",
        "aws_secret_key": "YOUR SECRET KEY GOES HERE"
    }

## Running Packer

Assuming Packer is already installed, from the top level of this repo, do this:

    packer build -var-file=variables.json example.json
