class PublicController < ApplicationController
  
  # GET /
  def index
  end
  
  # GET or POST /search?query=pizza
  def search
    @recipes = Recipe.find_by_contents params[:query]
  end
  
end
