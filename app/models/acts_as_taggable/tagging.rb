# encoding: utf-8
module ActsAsTaggable
  ##
  # Сущность "ссылка на объект на котором стоит тэг"
  #
  class Tagging < ActiveRecord::Base
    # Уместнее использовать название таблицы в единственном числе
    set_table_name "tagging"

    # Ссылка на тэг
    belongs_to :tag, :class_name => ActsAsTaggable.tag_class_name

    # Ссылка на объект
    belongs_to :taggable, :polymorphic => true

    def self.instantiate( record )
      # "Превращаемся" в сам объект на который ссылаемся
      klass = ActiveRecord::Base.send( :compute_type, record[ "taggable_type" ] )

      unless klass.is_a? Class
        raise StandartError, "Unknown object type: #{record[ "taggable_type" ]}."
      end

      object = klass.find record[ "taggable_id" ]
      object
    end
  end
end