# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  def login_as(user)
    @request.session[:user_id] = users(user).id
  end

  def cookie(name, value)
    @request.cookies[name.to_s] = CGI::Cookie.new(name.to_s, value.to_s)
  end

  # Something that looks like an uploaded filed
  # http://manuals.rubyonrails.com/read/chapter/28
  def uploaded_file(path, content_type="application/octet-stream", filename=nil)
    filename ||= File.basename(path)
    t = Tempfile.new(filename)
    FileUtils.copy_file(path, t.path)
    (class << t; self; end;).class_eval do
      alias local_path path
      define_method(:original_filename) { filename }
      define_method(:content_type) { content_type }
    end
    return t
  end

  # a JPEG helper
  def uploaded_jpeg(path, filename=nil)
    uploaded_file(path, 'image/jpeg', filename)
  end

  # a GIF helper
  def uploaded_gif(path, filename=nil)
    uploaded_file(path, 'image/gif', filename)
  end

  # a PNG helper
  def uploaded_png(path, filename=nil)
    uploaded_file(path, 'image/png', filename)
  end
end
