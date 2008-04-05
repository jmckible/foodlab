module AuthorizationSystem
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end
  
  protected
  def logged_in?
    !@current_user.nil?
  end

  # Returns the currently logged in user
  def current_user
    @current_user ||= User.find(session[:user_id])
  end
  
  # Assigns the current user
  def current_user=(user)
    return if user.nil?
    session[:user_id] = user.id
    cookies[:user_id] = user.id.to_s
    cookies[:password_hash] = user.password_hash
    @current_user = user
  end

  # Attemp login if session, cookie, or header authentication is present
  def login
    header_login || session_login || cookie_login || true
  end

  # To protect a controller, use this method as a filter
  # before_filter :login_required
  def login_required
    access_denied unless logged_in? || header_login || session_login || cookie_login
  end

  # If the user can't be logged in with supplied credentials
  # redirect to login page, or send 401 depending on request format
  def access_denied
    clear_session
    respond_to do |format|
      format.html { redirect_to new_session_path and return false }
      format.xml do
        headers['Status'] = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text =>'Unauthorized', :status=>401
      end
    end
  end

  # Log in using basic HTTP authorization headers
  def header_login
    auth_key  = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization).detect { |h| request.env.has_key?(h) }
    unless auth_key.blank?
      auth_data = request.env[auth_key].to_s.split
      if auth_data and auth_data[0] == 'Basic'
        email, password = Base64.decode64(auth_data[1]).split(':')[0..1]
        current_user = User.authenticate(email, password)
        return true unless user.nil?
      end
    end
    return false
  end

  # Log in using the session
  # Session is assumed to be secure
  def session_login
    @current_user = User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    return false
  end

  # Log in with cookie
  def cookie_login
    @current_user = User.find(cookies[:user_id])
    return @current_user.password_hash == cookies[:password_hash] 
  rescue 
    return false
  end
  
  # Save user to session and cookie
  def save_to_session
    session[:user_id] = @user.id
    cookies[:user_id] = {:value=>@user.id.to_s, :expires=>2.years.from_now}
    cookies[:password_hash] = {:value=>@user.password_hash, :expires=>2.years.from_now}
  end
  
  # Clean out the session and cookie 
  def clear_session
    session[:user_id] = nil
    cookies[:user_id] = nil
    cookies[:password_hash] = nil
  end
end