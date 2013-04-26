# you might want to put the key and secret in a configuration file
# that's not versioned with application code
Dropbox::API::Config.app_key    = 'u5510v34x43lv2g'
Dropbox::API::Config.app_secret = 'ayekxragg0jyw2m'
# 'sandbox' mode because designated app-exclusive directory is fine for us
Dropbox::API::Config.mode       = "sandbox" # if you have a single-directory app or "dropbox" if it has access to the whole dropbox