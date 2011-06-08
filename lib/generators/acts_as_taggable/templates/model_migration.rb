# encoding: utf-8
<%
  class_name = name.singularize.camelcase
  table_name = name.pluralize.underscore
-%>
class Create<%= class_name.pluralize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.column :parent_id, :integer                             # Родительский тэг
      t.column :name,  :string, :limit => 512, :null => false   # Имя
      t.column :count, :integer, :default => 0, :null => false  # Кол-во объектов, с данным тэгом
      t.column :moderated, :boolean, :default => false          # Тэг модерирован?
      t.timestamps
    end

    add_index :<%= table_name %>, [ :name, :moderated ]
    add_index :<%= table_name %>, :count

    execute %Q{
      CREATE OR REPLACE FUNCTION trg_update_<%= table_name %>_counter() RETURNS trigger AS '
      BEGIN
        IF tg_op = ''INSERT'' THEN
          UPDATE <%= table_name %>
             SET count = count + 1
           WHERE id = new.tag_id;

          RETURN new;

        ELSIF tg_op = ''DELETE'' THEN
          UPDATE <%= table_name %>
             SET count = count - 1
           WHERE id = old.tag_id;

          RETURN old;

        ELSE
          RETURN new;

        END IF;
      END
      ' LANGUAGE plpgsql;

      CREATE TRIGGER trg_update_<%= table_name %>_counter
               AFTER INSERT OR DELETE
                  ON tagging
        FOR EACH ROW EXECUTE PROCEDURE trg_update_<%= table_name %>_counter();
    }
  end

  def self.down
    execute %Q{
      DROP TRIGGER trg_update_<%= table_name %>_counter ON tagging;
      DROP FUNCTION trg_update_<%= table_name %>_counter();
    }
    drop_table :<%= table_name %>
  end
end