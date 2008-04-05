class RecipesController < ApplicationController
  before_filter :login_required, :only=>[:new, :create, :add_ingredient_to]
  
  def index
    @recipes = Recipe.paginate :all, :page=>params[:page], :order=>'created_at desc'
  end
  
  def show
    @recipe = Recipe.find params[:id]
  end
  
  def new
    @recipe = current_user.recipes.build
    10.times { @recipe.requirements.build }
  end
  
  def edit
    get_recipe
    # Ensure there are at least 5 ingredient fields
    if @recipe.ingredients.size < 6
      @recipe.ingredients.size.upto(4) { @recipe.requirements.build }
    end
  end
  
  def create
    @recipe = current_user.recipes.build params[:recipe]
    @recipe.save!
    @recipe.create_requirements! params[:requirements]
    @recipe.update_user_tags! current_user, params[:tags]
    redirect_to @recipe
  rescue ActiveRecord::RecordInvalid
    render :action=>:new
  end
  
  def update
    get_recipe
    @recipe.update_attributes! params[:recipe]
    @recipe.update_requirements! params[:requirements]  
    @recipe.update_user_tags! current_user, params[:tags]
    redirect_to @recipe
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end
  
  def add_ingredient_to
    @requirement = Requirement.new
    render :update do |page|
      page.insert_html :bottom, :Requirements, :partial=>'requirement', :locals=>{:requirement=>@requirement, :index=>params[:index]}
      page.replace_html :AddIngredient, link_to_remote('Add another ingredient', :url=>add_ingredient_to_recipes_path(:index=>(params[:index].to_i + 1)))
    end
  end
  
  def add_tags
    @recipe = Recipe.find params[:id]
    @recipe.add_user_tags! current_user, params[:tags]
    render :update do |page|
      page.replace_html :MyTags, :partial=>'tags/list', :locals=>{:recipe=>@recipe}
    end
  end
  
  protected
  def get_recipe
    if current_user.administrator?
      @recipe = Recipe.find params[:id]
    else
      @recipe = current_user.recipes.find params[:id]
    end
  end
end