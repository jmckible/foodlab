class IngredientsController < ApplicationController
  before_filter :administrator_required, :only=>:update
  
  # GET /ingredients/chicken
  def show
    @ingredient = Ingredient.find_by_url params[:id]
    @recipes = @ingredient.recipes.paginate :page=>params[:page]
  end
  
  # PUT /ingredients/chicken
  def update
    @ingredient = Ingredient.find_by_url params[:id]
    @ingredient.update_attributes! params[:ingredient]
    redirect_to @ingredient
  rescue ActiveRecord::RecordInvalid
    redirect_to @ingredient
  end
  
end
