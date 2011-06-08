# encoding: utf-8
ActsAsTaggable.configure do |config|
  config.tag_class_name = "<%= name.singularize.camelcase %>"
end