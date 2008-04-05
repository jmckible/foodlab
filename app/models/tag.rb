class Tag < ActiveRecord::Base
  def self.find_or_create_by_name(name)
    name = name.downcase.strip
    Tag.find(:first, :conditions=>{:name=>name}) || Tag.create(:name=>name)
  end
  
  def self.popular(limit=50)
    Tag.find :all, :order=>'taggings_count desc, name', :limit=>limit, :conditions=>'taggings_count != 0'
  end
  
  has_many :taggings
  has_many :recipes, :through=>:taggings, :uniq=>true, :order=>'rating desc, name'
  
  before_validation :clean_name
  before_validation :generate_url
  
  def to_param
    url
  end
  
  validates_presence_of :name, :url
  validates_uniqueness_of :name, :url,  :case_sensative=>false
  
  protected
  def clean_name
    self.name = name.downcase.strip unless name.nil?
  end
  
  def generate_url
    self.url = name.gsub(/[^a-z0-9]+/i, '-') unless name.blank?
  end
end
