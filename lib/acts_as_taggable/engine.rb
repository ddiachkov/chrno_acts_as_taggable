# encoding: utf-8
module ActsAsTaggable
  class Engine < Rails::Engine
    initializer "chrno_acts_as_taggable.initialize" do
      # Загрузка в AR
      ActiveSupport.on_load( :active_record ) do
        puts "--> load acts_as_taggable"
        extend ActsAsTaggable::ARExtension
      end
    end
  end
end