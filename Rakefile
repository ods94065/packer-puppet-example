require 'erb'
require 'json'
require 'yaml'

require 'rake/clean'

current_dir = File.dirname(__FILE__)
build_dir = "#{current_dir}/build"
puppet_build_dir = "#{build_dir}/puppet"
packs_build_dir = "#{build_dir}/packs"

directory build_dir
directory puppet_build_dir => [build_dir]
directory packs_build_dir => [build_dir]

nodes_file = "#{current_dir}/nodes.yaml"

def generate_puppet_manifest(data, anIO)
  data['classes'].each do |klass|
    anIO.puts("include #{klass}")
  end
end

def generate_packer_variables(node_name, data)
  return {
    'aws_access_key' => '',
    'aws_secret_key' => '',
  }
end

def generate_packer_builders(node_name, data)
  return [{
    'type' => 'amazon-ebs',
    'access_key' => '{{user `aws_access_key`}}',
    'secret_key' => '{{user `aws_secret_key`}}',
    'region' => 'us-east-1',
    'source_ami' => 'ami-de0d9eb7',
    'instance_type' => 't1.micro',
    'ssh_username' => 'ubuntu',
    'ami_name' => "packer-#{node_name} {{timestamp}}",
  }]
end

def generate_packer_provisioners(node_name, data)
  return [
    {
      'type' => 'shell',
      'inline' => [
        "echo 'Waiting 30s for box to initialize...'",
        'sleep 30',
      ]
    },
    {
      'type' => 'shell',
      'scripts' => [
        'scripts/install_puppet.sh',
        'scripts/install_common_puppet_modules.sh',
      ]
    },
    {
      'type' => 'file',
      'source' => 'puppet/hieradata',
      'destination' => '/tmp/hieradata',
    },
    {
      'type' => 'file',
      'source' => 'puppet/modules',
      'destination' => '/tmp/puppet-modules',
    },
    {
      'type' => 'shell',
      'inline' => [
        'sudo cp -r /tmp/hieradata /etc/puppet/hieradata',
        'sudo cp -r /tmp/puppet-modules/* /etc/puppet/modules',
        'rm -rf /tmp/{hieradata,puppet-modules}',
      ]
    },
    {
      'type' => 'puppet-masterless',
      'manifest_file' => "puppet/manifests/#{node_name}.pp",
      'hiera_config_path' => 'puppet/hiera.yaml',
      'execute_command' => %Q[{{.FacterVars}}{{if .Sudo}} sudo -E {{end}}puppet apply --verbose --detailed-exitcodes {{if ne .HieraConfigPath ""}}--hiera_config={{.HieraConfigPath}} {{end}}{{.ManifestFile}}],
    },
  ]
end

def generate_packer_obj(node_name, data)
  return {
    'variables' => generate_packer_variables(node_name, data),
    'builders' => generate_packer_builders(node_name, data),
    'provisioners' => generate_packer_provisioners(node_name, data),
  }
end

namespace :packs do
  namespace :all do
    desc "Validates all Packer specs"
    task :validate
    desc "Inspects all Packer specs"
    task :inspect
    desc "Builds all Packer images"
    task :build
  end
end

nodes = YAML.load_file(nodes_file)
nodes.each_pair do |node_name, data|
  if node_name == 'all'
    raise NameError("'all' is a special name; you cannot define a node with that name.")
  end

  puppet_manifest_file = "#{puppet_build_dir}/#{node_name}.pp"
  packer_build_file = "#{packs_build_dir}/#{node_name}.json"

  file puppet_manifest_file => [puppet_build_dir] do |t|
    puts "creating #{puppet_manifest_file}"
    File.open(t.name, 'w') do |f|
      generate_puppet_manifest(data, f)
    end
  end

  file packer_build_file => [packs_build_dir] do |t|
    puts "creating #{packer_build_file}"
    File.open(t.name, 'w') do |f|
      JSON.dump(generate_packer_obj(node_name, data), f)
    end
  end

  namespace :packs do
    namespace node_name do
      desc "Validates the Packer spec for #{node_name}"
      task :validate => [packer_build_file] do
        sh "packer validate #{packer_build_file}"
      end
      desc "Inspecs the Packer spec for #{node_name}"
      task :inspect => [packer_build_file] do
        sh "packer inspect #{packer_build_file}"
      end
      desc "Builds Packer images for #{node_name}"
      task :build => [puppet_manifest_file, packer_build_file] do
        sh %Q[packer build -var-file #{current_dir}/credentials.json #{packer_build_file}]
      end
    end
    namespace :all do
      task :validate => ["packs:#{node_name}:validate"]
      task :inspect => ["packs:#{node_name}:inspect"]
      task :build => ["packs:#{node_name}:build"]
    end
  end
end

if File.directory? build_dir
  CLEAN << build_dir
end
