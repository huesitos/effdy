class SettingsController < ApplicationController

	def settings
  	@view_title = t('.settings')
  end

  def update_settings
  	I18n.locale = params[:settings][:language]
  	user = User.find(session[:user_id])
  	user.update(locale: params[:settings][:language])

  	redirect_to settings_path
  end
end
