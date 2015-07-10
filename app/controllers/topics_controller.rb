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
    @total = Topic.count.to_i
    @topic_configs = TopicConfig.where(user_id: session[:user_id]).sort(reviewing: -1, archived: 1)

    @view_title = "Topics"
  end

  # GET /topics/1
  # GET /topics/1.json
  # Shows the topic's boxes. Empty boxes have a different icon.
  def show
    @view_title = @topic.title
    cts = @topic.cards_to_study(session[:user_id])
    @exist_cards_to_study = cts.to_a.length > 0

    @topic_config = @topic.topic_configs.find_by(user_id: session[:user_id])

    @card_statistics = {}

    CardStatistic.where(user_id: session[:user_id]).each do |cs|
      @card_statistics[cs.card_id] = cs
    end
  end

  # GET /topics/new
  def new
    @back = params[:back]
    @url = new_topic_path
    @view_title = "New topic"
    @topic = Topic.new
    @new = true
  end

  # GET /topics/1/edit
  def edit
    @view_title = "Editing topic"
    @topic_config = @topic.topic_configs.find_by(user_id: session[:user_id])
  end

  # POST /topics
  def create
    @topic = Topic.new(topic_params)
    @topic.subject = @topic_subject

    # If it has a subject, make sure they share the same owner
    # In case the current user is not the owner, then at least the subject user
    # will reference to the real owner
    if @topic_subject
      @topic.user = @topic_subject.user
    else
      @topic.user = User.find(session[:user_id])
    end

    respond_to do |format|
      if @topic.save

        # If the topic is in a subject, then grab all the collaborators and the owner
        # and make a config for them.
        # If not, then only make it for the owner.
        if @topic_subject
          collaborators = @topic_subject.subject_configs.pluck(:user_id)

          collaborators.each do |c|
            @topic.topic_configs.create(user_id: c)
          end
        else
          @topic.topic_configs.create(user_id: session[:user_id])
        end

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
        if @topic_subject
          @topic.update(subject_id: @topic_subject._id)
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
    @topic_config = @topic.topic_configs.find_by(user_id: session[:user_id])

    respond_to do |format|
      if @topic_config.reviewing
        @topic_config.update(reviewing: false)
      else
        @topic_config.update(reviewing: true)
      end

      format.html { redirect_to @topic }
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
      params[:subject_id].downcase != 'none' ? @topic_subject = Subject.find(params[:subject_id]) : @topic_subject = nil
    end

    # Search for all the subjects and the particular topic's subject, if exists
    def set_subjects
      if params[:id] 
        @topic_subject = Topic.find(params[:id]).subject
      elsif params[:subject] 
        @topic_subject = Subject.find(params[:subject])
      else
        @topic_subject = nil
      end

      if @topic_subject 
        @subjects = Subject.not_archived(session[:user_id]).where(:_id.ne => @topic_subject._id)
      else 
        @subjects = Subject.not_archived(session[:user_id])
      end
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
