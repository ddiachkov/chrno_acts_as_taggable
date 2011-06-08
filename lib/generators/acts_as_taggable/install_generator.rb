# encoding: utf-8
require "rails/generators"
require "rails/generators/migration"
require "active_record"

# Генератор создаёт новую модель тэгов и миграцию к ней
module ActsAsTaggable
  class InstallGenerator < Rails::Generators::NamedBase
    source_root File.expand_path( "../templates", __FILE__ )
    desc "generates tag model"

    def make_tagging_migration
      migration_template "tagging_migration.rb", "db/migrate/create_tagging"
    end

    def make_model_migration
      migration_template "model_migration.rb", "db/migrate/create_#{name.pluralize.underscore}"
    end

    def make_model
      template "model.rb", File.join( Rails.root, "app", "models", "#{name.singularize.underscore}.rb" )
    end

    def make_initializer
      if name.singularize.camelcase != "Tag"
        template "initializer.rb", File.join( Rails.root, "config", "initializers", "acts_as_taggable.rb" )
      end
    end

    private

    include Rails::Generators::Migration

    # Код взят из генератора моделей
    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      if ActiveRecord::Base.timestamped_migrations
        [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
      else
        "%.3d" % next_migration_number
      end
    end
  end
end