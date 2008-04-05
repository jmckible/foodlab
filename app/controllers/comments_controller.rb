class CommentsController < ApplicationController
  before_filter :login_required 
  before_filter :load_recipe

  # GET /recipes/1-pizza/comments/new
  def new
    @comment = @recipe.comments.build
  end

  # POST /comments
  def create
    @comment = @recipe.comments.build params[:comment]
    @comment.user = current_user
    @comment.save!
    UserNotifier.deliver_comment @comment
    redirect_to @comment.recipe
  end

 protected
 def load_recipe
   @recipe = Recipe.find params[:recipe_id]
 end
end
