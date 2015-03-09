class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_context

  def filter_subject
  	respond_to do |format|
  		format.html { redirect_to request.referrer, flash: { subject: params[:subject] } }
  	end
  end

  private
    def set_context
  		@app_subjects = Subject.not_archived

      if flash[:subject]
        if flash[:subject] == "all"
          @menu_topics = Topic.not_archived
        elsif flash[:subject] == "none"
          @menu_topics = Topic.not_archived.where(subject_id: nil)
        else
          subject = Subject.find_by(code: flash[:subject])
          @menu_topics = Topic.where(subject_id: subject._id)
        end
      else
        @menu_topics = Topic.not_archived
      end

  	end
end
