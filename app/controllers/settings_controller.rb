class SettingsController < ApplicationController
	before_action :authenticate_user!
	
	def settings
  	@view_title = t('.settings')
  end

  def update_settings
  	I18n.locale = params[:settings][:language]
  	user = User.find(session[:user_id])
  	user.update(locale: params[:settings][:language])

  	redirect_to settings_path
  end

  def feedback
    @view_title = t('.feedback')
    @feedback = Feedback.new()
  end

  def add_feedback
    @view_title = t('.feedback')
    @feedback = Feedback.new(feedback_params)
    @feedback.user = session[:user_id]
    
    if @feedback.save
      flash[:success] = t(".thanks")
      redirect_to feedback_url
    else
      render :feedback
    end

  end

  private

    def feedback_params
      params.require(:feedback).permit(:content)
    end
end
