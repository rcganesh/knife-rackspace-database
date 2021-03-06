require 'chef/knife'
require 'chef/knife/rackspace_base'
require 'chef/knife/rackspace_database_instance_related'

module KnifePlugins
  class RackspaceDatabaseDbList < Chef::Knife

    include Chef::Knife::RackspaceBase
    include Chef::Knife::RackspaceDatabaseBase
    include Chef::Knife::RackspaceDatabaseInstanceRelated

    banner "knife rackspace database db list INSTANCE_NAME"

    def run
      $stdout.sync = true

      pop_instance_arg

      db_list = [
          ui.color('Name', :bold)
      ]

      @instance.databases.each do |database|
        db_list << database.name
      end

      puts ui.list(db_list, :uneven_columns_across, 1)
    end

  end
end
