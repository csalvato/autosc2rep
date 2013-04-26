class ReplayController < ApplicationController
  def download
  	replay = Replay.find(params[:replay_id])
  	client = Dropbox::API::Client.new(:token  => current_user.dropbox_access_key, :secret => current_user.dropbox_access_secret)
		replay_file_for_download = client.find( replay.path ).download
		filename = replay.path.split('/').last
		send_data replay_file_for_download, filename: filename,
																				type: "application/octet-stream", 
																				x_sendfile: true
  end
end
