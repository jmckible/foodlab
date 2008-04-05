require 'digest/sha1'
class User < ActiveRecord::Base
  ##########################################
  #       C L A S S   M E T H O D S        #
  ##########################################
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    user = User.find_by_email email
    user and (self.encrypt(password, user.password_salt) == user.password_hash) ? user : nil
  end
  
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt) 
  end

  ##########################################
  #        R E L A T I O N S H I P S       #
  ##########################################
  has_many :bookmarks, :protected=>true, :order=>'created_at desc, id desc'
  has_many :bookmarked_recipes, :through=>:bookmarks, :source=>:recipe, :order=>'bookmarks.created_at desc, bookmarks.id desc'
  has_many :comments,  :protected=>true
  has_many :ratings,   :protected=>true
  has_many :recipes,   :protected=>true, :order=>'created_at desc'
  has_many :taggings,  :protected=>true
  has_many :tags, :through=>:taggings, :order=>'taggings_count desc', :uniq=>true

  ##########################################
  #       O B J E C T   M E T H O D S      #
  ##########################################
  def name() "#{first_name} #{last_name}" end
  
  # Users can not be deleted right now
  def destroy() raise Exception::ImmutableRecordException end
  
  ##########################################
  #            V A L I D A T I O N         #
  ##########################################
  attr_accessor :password
  attr_protected :password_hash, :password_salt, :password_reset_token, :created_at, :updated_at, :administrator
  
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  validates_length_of       :email, :within => 5..100
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_presence_of     :email
  
  validates_presence_of     :first_name, :last_name
  validates_presence_of     :password_confirmation,      :if=>:update_password?
  validates_length_of       :password, :within => 4..40, :if=>:update_password?
  validates_confirmation_of :password,                   :if=>:update_password?
  
  before_save :encrypt_password
   
  protected
  def update_password?
    new_record? or !password.blank?
  end
  
  def encrypt_password 
    return if password.blank?
    self.password_salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp if new_record?
    self.password_hash = self.class.encrypt(password, self.password_salt) 
  end
  
end