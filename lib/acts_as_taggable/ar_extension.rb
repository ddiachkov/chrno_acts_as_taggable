# encoding: utf-8
require "active_record"

module ActsAsTaggable
  # Расширения для ActiveRecord
  module ARExtension
    ##
    # Добавляет модели теги.
    #
    # @param [#to_sym] association_name название ассоциации
    #
    def acts_as_taggable( association_name = :tags )
      # Tags -> Tagging
      join_association_name = association_name.to_s.present_participle.to_sym

      # Связка
      has_many join_association_name,
        :class_name => "ActsAsTaggable::Tagging",
        :as         => :taggable,
        :autosave   => true

      # Теги
      has_many association_name,
        :through    => join_association_name,
        :source     => :tag,
        :extend     => ProxyExtension,
        :uniq       => true,
        :autosave   => true

      # Начиная с 3.1 установка значения идёт в обход прокси объекта, поэтому
      # делаем свой сеттер.
      define_method "#{association_name}=" do |value|
        association( association_name ).proxy.replace( value )
      end
    end
  end

  private

  # Модуль расширения для прокси тегов
  module ProxyExtension
    # Переопределяем сеттер коллекции таким образом, чтобы можно было
    # передавать строки и массивы
    def replace( value )
      @association.replace to_tag_array( value, :create => true )
    end

    # Добавляет тег.
    def add( *tags )
      @association.transaction do
        @association.concat to_tag_array( *tags, :create => true )
      end
    end

    # Удаляет тег.
    def delete( *tags )
      @association.delete to_tag_array( *tags )
    end

    # Возвращат строку тэгов через запятую (для форм).
    def to_s
      self.map( &:name ).join( ", " )
    end

    private

    ##
    # Преобразование аргумента в массив тэгов.
    # Если задано :create => true (false по умолчанию), то автоматически
    # создаётся новый тэг.
    #
    def to_tag_array( *args )
      options = { :create => false }.merge args.extract_options!

      tag_maker =
        if options[ :create ]
          Proc.new { |name| ActsAsTaggable.tag_class.find_or_create_by_name( name ) }
        else
          Proc.new { |name| ActsAsTaggable.tag_class.find_by_name( name )}
        end

      # 1) Делаем одномерный массив
      # 2) Разделяем массив на 2 части: объекта типа tag_class и всё остальное
      # 3) Каждый элемент "всего остального" преобразуем к строке (to_s)
      # 4) Дробим строки на подстроки
      # 5) Удаляем пустые и дублирующиеся строки
      # 6) Преобразуем строки в тэги
      # 7) Склеиваем половинки и убираем дубли
      tags, objects = *args.flatten.partition { |t| t.is_a? ActsAsTaggable.tag_class }

      objects = objects               \
        .map( &:to_s )                \
        .map { |t| t.split( "," ) }   \
        .flatten                      \
        .map( &:strip )               \
        .reject( &:blank? )           \
        .uniq                         \
        .map { |t| tag_maker.call t } \
        .compact

      ( tags + objects ).uniq
    end
  end
end