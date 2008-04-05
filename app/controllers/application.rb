# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthorizationSystem
  #include ExceptionNotifiable
  
  #ExceptionNotifier.exception_recipients = %w(jmckible@corkboardinc.com)
  #ExceptionNotifier.sender_address = %("Application Exception" <exception@foodlab.com>)
    
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_foodlab_session_id'
  
  filter_parameter_logging 'password'
  
  before_filter :login
  
  def administrator_required
    redirect_to home_path unless logged_in? && current_user.administrator?
  end
end
