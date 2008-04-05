class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe
  
  acts_as_textiled :body
  
  validates_presence_of :body, :user, :recipe

end
