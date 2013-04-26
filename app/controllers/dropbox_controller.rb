class DropboxController < ApplicationController
  def authorize
    @user = User.first
    sign_in(@user)
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = consumer.get_request_token
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => 'http://0.0.0.0:3000/authcallback') #change this URL with the one where it should go after authorization
  end

  def authorized_callback
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
    
    current_user.dropbox_access_key = access_token.token
    current_user.dropbox_access_secret = access_token.secret
    current_user.save!
    flash[:success] = "Your Dropbox account is now linked.  Your replays will be ready in a few minutes!"
    redirect_to '/'
  end

  def update_replays
    current_user.update_replays
  end
end