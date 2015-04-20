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

  protected
  
    # Method to determine or set the current user
    def current_user
      @current_user ||= User.find_by(username: session[:user_uname])
    end

    # Method to determine whether a user is signed in or not
    def user_signed_in?
      !!current_user
    end

    helper_method :current_user, :user_signed_in?
    
    def current_user=(user)
      session[:user_uname] = user.username
      session[:user_name] = user.name
    end

  private

    # Sets the context for the topics menu. Only the unarchived subjects,
    # and topics are picked. The topics are filtered based on the subject
    # code in cache.
    def set_context
      @app_subjects = Subject.from_user(session[:user_uname])
      @app_subjects = @app_subjects.not_archived if @app_subjects

      cache = Rails.cache

      @menu_topics = Topic.from_user(session[:user_uname])

      if @menu_topics
        if cache.read('subject')
          @selected_subject = cache.read('subject')
          if @selected_subject == "all"
            @menu_topics = @menu_topics.not_archived
          elsif @selected_subject == "none"
            @menu_topics = @menu_topics.not_archived.where(subject_id: nil)
          else
            subject = @app_subjects.find_by(code: @selected_subject)
            @menu_topics = @menu_topics.where(subject_id: subject._id)
          end
        else
          @menu_topics = @menu_topics.not_archived
        end

        @menu_topics = @menu_topics.sort(reviewing:-1)
      end
    end
    
    def authenticate_user!
      if session[:user_uname].nil?
        redirect_to root_url
      end
    end
end
