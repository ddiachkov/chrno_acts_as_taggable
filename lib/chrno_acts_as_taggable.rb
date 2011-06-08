# encoding: utf-8
module ActsAsTaggable
  autoload :ARExtension, "acts_as_taggable/ar_extension"
  autoload :VERSION,     "acts_as_taggable/version"

  # Название класса тегов
  mattr_accessor :tag_class_name
  @@tag_class_name = "Tag"

  ##
  # Конфигурация модуля.
  #
  def self.configure
    yield self
  end

  ##
  # Возвращает класс тегов.
  # @return [Class]
  #
  def self.tag_class
    self.tag_class_name.split( "::" ).inject( Object ) { |par, const| par.const_get( const ) }
  end
end

require "acts_as_taggable/engine"