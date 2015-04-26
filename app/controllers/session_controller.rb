class SessionController < ApplicationController
  def create
  	# find_or_create_from_hash method is defined in app/models/users.rb
		# the method finds an existing user, or creates a new one
		@user = User.find_or_create_from_auth_hash(auth_hash)
		# current_user= method defined in app/controllers/application_controller.rb
		# the method sets the session variables
		self.current_user = @user
		redirect_to todays_study_path
  end

  def destroy
  	reset_session
  	cache = Rails.cache
    cache.write('subject', '')
  	# Go back to welcome page
		redirect_to root_url
  end

  protected

		def auth_hash
			request.env['omniauth.auth']
		end
end
