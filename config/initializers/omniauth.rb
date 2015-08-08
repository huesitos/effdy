Rails.application.config.middleware.use OmniAuth::Builder do
  # Keep keys out of your Git repository! This uses environment variables from your
  # shell's configuration file (e.g., .zshrc if you're using zsh). You'll need lines
  # like
  # export WANTADS_TWITTER_KEY=a2dfOXZJgdfdsb888asdf
  # export WANTADS_TWITTER_SECRET=asdfabaj8834AFJDKFasdfasjjksdfsdlkljsdfsd
  # in your .zshrc file. In order to obatin your Twitter Key and Twitter Secret,
  # you need to first log into https://dev.twitter.com/ and create a new application
  provider :twitter,
    Rails.application.secrets.twitter_key,
    Rails.application.secrets.twitter_secret
  provider :google_oauth2,
    Rails.application.secrets.google_client_id,
    Rails.application.secrets.google_client_secret
  provider :facebook,
    Rails.application.secrets.facebook_app_id,
    Rails.application.secrets.facebook_secret
end
