# TopicsController
class TopicsController < ApplicationController
  before_action :set_topic, except: [:new, :index, :create]
  before_action :set_subjects, only: [:new, :edit]
  before_action :set_errors, only: [:new, :edit]
  before_action :set_subject, only: [:create, :update]
  before_action :authenticate_user!

  # GET /topics
  # GET /topics.json
  # Shows the complete list of topics
  def index
    @subjects = Subject.only(:code).all

    if params[:commit] == "Search" and params[:subject] != ""
      if params[:subject] == "all"
        @topics = Topic.all
      elsif params[:subject] == "none"
        @topics = Topic.where(subject_id: nil)
      else
        subject = Subject.find_by(code: params[:subject])
        @topics = Topic.where(subject_id: subject._id)
      end
    else
      @topics = Topic.all
    end
    @topics = @topics.from_user(session[:user_id])

    @view_title = "Topics"
  end

  # GET /topics/1
  # GET /topics/1.json
  # Shows the topic's boxes. Empty boxes have a different icon.
  def show
    @view_title = @topic.title
    cts = @topic.cards_to_study(session[:user_id])
    @exist_cards_to_study = cts.to_a.length > 0
  end

  # GET /topics/new
  def new
    @back = params[:back]
    @url = new_topic_path
    @view_title = "New topic"
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
    @view_title = "Editing topic"
  end

  # POST /topics
  def create
    @topic = Topic.new(topic_params)
    @topic.subject = @subject
    @topic.user = User.find(session[:user_id])

    respond_to do |format|
      if @topic.save
        format.html {
          flash[:success] = 'Topic created successfully.'

          redirect_to @topic
        }
      else
        format.html { redirect_to new_topic_path(errors: @topic.errors.full_messages.each.to_a) }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        if @subject
          @topic.update(subject_id: @subject._id)
        end

        format.html {
          flash[:success] = 'Topic updated successfully.'

          redirect_to @topic
        }
      else
        format.html { redirect_to edit_topic_path(errors: @topic.errors.full_messages.each.to_a) }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html {
        flash[:success] = 'Topic deleted successfully.'

        redirect_to topics_path
      }
      format.json { head :no_content }
    end
  end

  # PATCH /topics/:id/set_reviewing
  # Sets the topic for reviewing.
  def set_reviewing
    respond_to do |format|
      if @topic.reviewing
        @topic.update(reviewing: false)
      else
        @topic.update(reviewing: true)
      end

      format.html { render @topic }
    end
  end

  # PATCH /topics/:id/reset_cards
  # Resets all the cards to box 1.
  def reset_cards
    @topic.reset_cards

    respond_to do |format|
      format.html { redirect_to @topic }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      params[:id] ? @topic = Topic.find(params[:id]) : @topic = Topic.find(params[:topic_id])
    end

    # Set the subject specified by the param[:subject].
    def set_subject
      params[:subject_id].downcase != 'none' ? @subject = Subject.find(params[:subject_id]) : @subject = nil
    end

    # Search for all the subjects and the particular topic's subject, if exists
    def set_subjects
      user = User.find(session[:user_id])
      params[:id] ? @subject = Topic.find(params[:id]).subject : @subject = nil

      @subject ? @subjects = Subject.where(:_id.ne => @subject._id, :archived => false, user_id: user._id) : @subjects = Subject.not_archived.where(user_id: user._id)
    end

    # Pack errors in a variable to be shown in the form
    def set_errors
      @errors = params[:errors] if params[:errors]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :subject)
    end
end
