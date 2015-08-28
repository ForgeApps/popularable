require 'rails/generators'

module Popularable
  class InstallGenerator < ::Rails::Generators::Base
    desc "Install a migration for the popularable gem"
    source_root File.expand_path('../generators', __FILE__)

    def create_migration_file
      destination = "db/migrate/#{Time.now.utc.strftime('%Y%m%d%H%M%S')}_popularable_installation_migration.rb".gsub(" ", "")
      migration_name = "PopularableInstallationMigration".gsub(" ", "")
      count = nil
      i = 1
      while !Dir.glob("db/migrate/*_popularable_installation_migration.rb".gsub(" ", "")).empty?
        i += 1
        count = "_#{i}"
        destination = "db/migrate/#{Time.now.utc.strftime('%Y%m%d%H%M%S')}_popularable_installation_migration.rb".gsub(" ", "")
        migration_name = "PopularableInstallationMigration#{i}".gsub(" ", "")
      end
      create_file destination, <<-FILE
class #{migration_name} < ActiveRecord::Migration
  def change
    create_table :popularable_popularity_events do |t|
      t.string  :popularable_type
      t.integer :popularable_id

      t.date :popularity_event_date
      t.integer :popularity, default: 0

      t.timestamps null: false
    end

    add_index :popularable_popularity_events, [:popularable_type, :popularable_id], name: "index_popularable_popularity_events_type_id"
    add_index :popularable_popularity_events, [:popularable_type, :popularable_id, :popularity], name: "index_popularable_popularity_events_type_id_popularity"
    add_index :popularable_popularity_events, :popularity
  end
end
FILE
    end
  end
end
