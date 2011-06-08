# encoding: utf-8
class CreateTagging < ActiveRecord::Migration
  def change
    create_table :tagging do |t|
      t.column :tag_id, :integer, :null => false       # Ссылка на тэг
      t.column :taggable_id, :integer, :null => false  # Ссылка на объект
      t.column :taggable_type, :string, :null => false
    end

    add_index :tagging, :tag_id
    add_index :tagging, [ :taggable_id, :taggable_type ]
  end
end