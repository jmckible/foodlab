class Recipe < ActiveRecord::Base

  #############################################################################
  #                          C L A S S   M E T H O D S                        #
  #############################################################################
  cattr_reader :per_page
  @@per_page = 20
  
  def self.newest(limit=5) 
    find :all, :order=>'created_at desc, id desc', :limit=>limit
  end
  
  def self.top(limit=5)
    find :all, :order=>'rating desc, created_at desc', :limit=>limit
  end
  
  # Cleans out the requirements hash that comes from the controller
  # Makes keys into integers so they sort properly
  # Removes all empty values
  def self.clean_requirements_hash(params)    
    params = params.integerize_keys.to_sorted_array.each(&:symbolize_keys!).reject{|h|h[:name].blank?}
    return params || []
  end

  #############################################################################
  #                          R E L A T I O N S H I P S                        #
  #############################################################################
  belongs_to :user, :protected=>true
  
  has_many :comments
  has_many :ratings
  has_many :requirements, :protected=>true
  has_many :ingredients, :through=>:requirements, :uniq=>true
  has_many :taggings
  has_many :tags, :through=>:taggings, :order=>'taggings_count desc, name', :uniq=>true do
    def from(user)
      find :all, :conditions=>['taggings.user_id = ?', user.id], :order=>'taggings.updated_at, taggings.id'
    end
    def top(limit=1)
      find :all, :limit=>limit
    end
  end
  
  def update_user_tags!(user, tag_list)
    Tagging.find(:all, :conditions=>{:recipe_id=>id, :user_id=>user.id}).each(&:destroy) and return if tag_list.blank?   
    
    current_tags = tags.from(user)
    tags = tag_list.split(',').collect{|name| Tag.find_or_create_by_name name}
    for tag in tags
      Tagging.create :user=>user, :recipe=>self, :tag=>tag unless current_tags.include?(tag)
    end
    
    for tag in current_tags
      unless tags.include?(tag)
        Tagging.find(:first, :conditions=>{:recipe_id=>id, :tag_id=>tag.id, :user_id=>user.id}).destroy
      end
    end
  end
  
  def add_user_tags!(user, tag_list)
    new_tags = tag_list.split(',').collect{|name| Tag.find_or_create_by_name name}
    for tag in new_tags
      Tagging.create :user=>user, :recipe=>self, :tag=>tag unless tags.include?(tag)
    end
  end
  
  def update_rating!
    if ratings.size == 0
      self.rating = 0
    else
      self.rating = ratings.sum(:value) / ratings.size.to_f 
    end
    save!
  end
  
  #############################################################################
  #                         O B J E C T    M E T H O D S                      #
  #############################################################################
  acts_as_textiled :process
  acts_as_ferret :fields=>{
      :name=>{}, :process=>{:boost=>0.5}, :tag_list=>{}, :ingredients_list=>{}, :author_name=>{},
      :rating=>{:index=>:untokenized}, :created_at_sort=>{:index=>:untokenized_omit_norms, :term_vector=>:no}
    }

  attr_protected :created_at, :updated_at

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-').downcase}"
  end
  
  def tag_list
    tags.collect(&:name).join(' ')
  end
  
  def ingredients_list
    ingredients.collect(&:name).join(' ')
  end
  
  # Coverts created_at to an integer for sorting in Ferret
  def created_at_sort
    created_at.to_i
  end
  
  def author_name
    user.name unless user.nil?
  end

  #############################################################################
  #                   M A N A G E     R E Q U I R E M E N T S                 #
  #############################################################################

  # These methods take in params style hashes for easy integration with controller
  # e.g. {"0"=>{"name"=>"water", "quantity"=>"20 oz"}, "1"=>{"name"=>"flour", "quantity"=>"3 c"}}
  
  def create_requirements!(params)
    return [] if params.nil?
    Recipe.clean_requirements_hash(params).each{|hash| requirements.create! hash}
  end

  def update_requirements!(params)
    return requirements if params.nil?
    array = Recipe.clean_requirements_hash params
        
    # Update or create by hash
    array.each_with_index do |hash, i|
      if requirements[i].nil?
        requirements.create! hash
      else
        requirements[i].update_attributes! hash
      end
    end 
    
    # Delete requirement past the hash
    array.size.upto(requirements.size - 1){|i| requirements[i].destroy}
    
    return requirements.reload
  end

  #############################################################################
  #                                V A L I D A T I O N                        #
  #############################################################################
  validates_presence_of :user, :name, :process

end
