# encoding: utf-8
module ActsAsTaggable
  ##
  # Сущность "тэг"
  #
  class Tag < ActiveRecord::Base
    # Этот класс будет наследоваться
    self.abstract_class = true

    # Ссылки на объекты (превращаются в сами объекты)
    has_many :objects,
      :class_name => "ActsAsTaggable::Tagging",
      :as         => :tag,
      :dependent  => :destroy

    # Ссылка на родительский тэг
    belongs_to :parent,
      :class_name => self.class.name,
      :dependent  => :destroy

    # Поиск по подстроке
    scope :like, lambda { |s| where( s.blank? ? "1 = 0" : arel_table[ :name ].matches( "%#{s}%" )) }

    # Топ-n тэгов по кол-ву объектов
    scope :top, lambda { |n| order( "count DESC" ).limit( n.to_i ) }

    # Отмодерированные тэги
    scope :moderated, where( :moderated => true )

    # Сравение
    def <=>( other )
      self.name.strip.lowercase <=> other.name.strip.lowercase
    end

    def to_s
      self.name
    end

    class << self
      # По умолчанию рельсы для дочерних классов используют таблицу
      # родительского класса -- нам это не подходит
      def table_name
        undecorated_table_name( name )
      end

      def instantiate( record )
        # Если у меня есть родитель
        unless record[ "parent_id" ].nil?
          # Превращаемся в родителя
          object = self.find record[ "parent_id" ]
          object
        else
          # Иначе ничего не делаем
          super( record )
        end
      end
    end
  end
end