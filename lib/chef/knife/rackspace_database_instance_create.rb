require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_base'

module KnifePlugins
  class RackspaceDatabaseInstanceCreate < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase

    banner "knife rackspace database instance create INSTANCE_NAME"

    option :flavor,
           :short => "-f FLAVOR",
           :long => "--flavor FLAVOR",
           :description => "The flavor of server; default is 1 (512 MB)",
           :default => 1

    option :size,
           :short => "-s SIZE",
           :long => "--volume-size SIZE",
           :description => "The volume size of the database in gigabytes; default is 10",
           :default => 10

    option :instance_create_timeout,
           :long => "--instance-create-timeout timeout",
           :description => "How long to wait until the instance is ready; default is 600 seconds",
           :default => 600
           
    def run
      $stdout.sync = true

      if @name_args.first.nil?
        show_usage
        error("INSTANCE_NAME is required")
        exit 1 
      end

      instance_name = @name_args.first

      instance = db_connection.instances.new(:name => instance_name,
                                         :flavor_id => config[:flavor],
                                         :volume_size => config[:size])
      instance.save

      msg_pair("Instance ID", instance.id)
      msg_pair("Name", instance.name)
      msg_pair("Flavor", instance.flavor.name)
      msg_pair("Volume Size", instance.volume_size)

      instance.wait_for(Integer(config[:instance_create_timeout])) { print "."; ready? }

      msg_pair("Hostname", instance.hostname)


    end

  end
end
