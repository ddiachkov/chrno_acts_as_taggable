# encoding: utf-8
Rails.application.routes.draw do
  namespace :acts_as_taggable, :path => "/tags", :as => :tags do
    controller :tags do
      match :suggest
      match :cloud
    end
  end
end