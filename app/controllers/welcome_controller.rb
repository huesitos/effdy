class WelcomeController < ApplicationController
  def welcome
  	render "index"
  end

  def getting_started
  	if params[:user_id]
	  	@user = User.find(params[:user_id])
	  else
	  	@user = nil
  	end
  	
  	render "getting_started"
  end
end
