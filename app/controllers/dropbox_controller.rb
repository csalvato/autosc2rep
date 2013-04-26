class DropboxController < ApplicationController
  def authorize
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = consumer.get_request_token
    cookies[:request_token] = request_token.token
    cookies[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => authcallback_url)
  end

  def authorized_callback
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    request_token = OAuth::RequestToken.new(consumer, cookies[:request_token], cookies[:request_token_secret])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
    
    current_user.dropbox_access_key = access_token.token
    current_user.dropbox_access_secret = access_token.secret
    current_user.save!
    flash[:success] = "Your Dropbox account is now linked.  Your replays will be ready in a few minutes!"
    redirect_to root_path
  end

  def update_replays
    current_user.update_replays
  end
end