class TaggingsController < ApplicationController
  before_filter :login_required
  
  # DELETE /taggings/1
  def destroy
    @tagging = current_user.taggings.find params[:id]
    @tagging.destroy
    render :update do |page|
      page.visual_effect :fade, dom_id(@tagging)
    end
  end
  
end
