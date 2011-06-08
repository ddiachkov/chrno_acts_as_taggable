# Описание
__chrno_acts_as_taggable__ -- реализация тегов для Rails.

Имеет следующие «фишки»:

 - позволяет легко добавлять теги к любой сущности без необходимости создания дополнительных таблиц;
 - есть возможность автозамены одного тега на другой («слияние» тегов);
 - позволяет работать с тегами, как со строкой;
 - в комплекте идут экшены для jQuery UI combobox compatible автодополнения и chrno_cloud compatible облака.

## Пример использования:

    rails g acts_as_taggable:install
    rake db:migrate
    ...
    class Post < ActiveRecord::Base
      acts_as_taggable
    end
    ...
    class Photo < ActiveRecord::Base
      acts_as_taggable
    end
    ...
    @photo = Photo.first
    @photo.tags                 #=> []
    @photo.tags = "tag1, tag2"
    @photo.tags                 #=> [ <Tag name="tag1">, <Tag name="tag2"> ]
    @photo.tags.to_s            #=> "tag1, tag2"
    @photo.tags.add "tag3"
    @photo.tags.delete "tag1"
    @photo.tags                 #=> [ <Tag name="tag2">, <Tag name="tag3"> ]

Форма:

    <%= form_for @post do %>
      ...
      <%= f.text_field :tags >
      ...
    <% end %>