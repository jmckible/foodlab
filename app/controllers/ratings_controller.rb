class RatingsController < ApplicationController
  before_filter :login_required
  
  # POST /ratings
  def create
    @rating = current_user.ratings.build 
    @rating.recipe_id = params[:recipe_id].to_i
    @rating.value = params[:value].to_i
    @rating.save!
    render :update do |page|
      page.replace_html 'Rating', @rating.recipe.rating
      page.replace_html 'Rate', :partial=>'ratings/edit', :object=>@rating
    end
  end

  # PUT /ratings/1
  def update
    @rating = current_user.ratings.find params[:id]
    @rating.value = params[:value]
    @rating.save!
    render :update do |page|
      page.replace_html 'Rating', @rating.recipe.rating
      page.replace_html 'Rate', :partial=>'ratings/edit', :object=>@rating
    end
  end

end
