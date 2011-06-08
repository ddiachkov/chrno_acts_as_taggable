# encoding: utf-8
module ActsAsTaggable
  class TagsController < ApplicationController
    respond_to :json

    # Автодополнение тегов.
    # /tags/suggest?term=some%20string
    def suggest
      respond_with ActsAsTaggable.tag_class \
        .like( params[ :term ] )            \
        .select( :name )                    \
        .map( &:name )
    end

    # Облако тегов.
    # /tags/cloud?limit=10
    def cloud
      respond_with ActsAsTaggable.tag_class \
        .moderated                          \
        .top( params[ :limit ] )            \
        .order( "created_at DESC" )         \
        .select([ :id, :name, :count ])
    end
  end
end