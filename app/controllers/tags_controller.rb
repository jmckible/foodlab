class TagsController < ApplicationController
  
  # GET /tags/quick
  def show
    @tag = Tag.find_by_url params[:id]
    @recipes = @tag.recipes.paginate :page=>params[:page]
  end
  
end
