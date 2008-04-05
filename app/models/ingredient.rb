class Ingredient < ActiveRecord::Base
  def self.popular(limit=40)
    Ingredient.find :all, :order=>'requirements_count desc, name', :limit=>limit, :conditions=>'requirements_count != 0'
  end

  has_many :requirements, :protected=>true
  has_many :recipes, :through=>:requirements, :select=>'distinct recipes.*', :order=>'rating desc, name'

  attr_protected :created_at, :updated_at
  
  before_validation :generate_url

  def before_validation
    self.name = name.strip unless name.nil?
  end
  
  def increment_usages!
    self.usages = usages + 1
    save!
  end
  
  def decrement_usages!
    self.usages = usages - 1 unless usages == 0
    save!
  end

  def to_param
    url
  end

  validates_presence_of   :name, :url
  validates_uniqueness_of :name, :url
  
  def generate_url
    self.url = name.gsub(/[^a-z0-9]+/i, '-') unless name.blank?
  end  
end
