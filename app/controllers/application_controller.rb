# ApplicationController
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_context, except: [:filter_subject, :welcome]

  # GET /filter_subject
  # Saves the subject code in the parameter to filter the
  # topics in the list. Then it redirects to the previous view. 
  def filter_subject
    cache = Rails.cache
    cache.write('subject', params[:subject])
  	respond_to do |format|
  		format.html { redirect_to request.referrer  }
  	end
  end

  helper_method :current_user

  def current_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = nil
    end
  end

  def current_user=(user)
    session[:user_uname] = user.username
    session[:user_name] = user.name
    session[:user_id] = user.id.to_s
  end

  private

    # Sets the context for the topics menu. Only the unarchived subjects,
    # and topics are picked. The topics are filtered based on the subject
    # code in cache.
    def set_context
      @app_subjects = Subject.from_user(session[:user_id])

      cache = Rails.cache

      @menu_topics = Topic.from_user(session[:user_id])

      # if @menu_topics
      #   if cache.read('subject') != "" and cache.read('subject')
      #     @selected_subject = cache.read('subject')
      #     if @selected_subject == "all"
      #       @menu_topics = @menu_topics.not_archived
      #     elsif @selected_subject == "none"
      #       @menu_topics = @menu_topics.not_archived.where(subject_id: nil)
      #     else
      #       subject = @app_subjects.find_by(code: @selected_subject)
      #       @menu_topics = @menu_topics.where(subject_id: subject._id)
      #     end
      #   else
      #     @menu_topics = @menu_topics.not_archived
      #   end

      #   @menu_topics = @menu_topics.sort(reviewing:-1).limit(15)
      # end
    end
    
    def authenticate_user!
      redirect_to login_path unless current_user
    end
end
