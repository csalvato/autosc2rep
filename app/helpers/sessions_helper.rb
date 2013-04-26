module SessionsHelper
	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def signed_in_user
    unless signed_in?
      store_location
      flash[:notify] = 'You need an account to print puzzles.  Signing up is free and takes 10 seconds.'
      redirect_to signup_path 
    end
  end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user?(user)
		current_user ==  user
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def store_location
		session[:return_to] = request.url
		session[:params] = YAML::dump(params)
 	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
		session.delete(:params)
	end
end
