class TopicsController < ApplicationController
  before_action :set_topic, except: [:new, :index, :create]
  before_action :set_subjects, only: [:new, :edit]
  before_action :set_errors, only: [:new, :edit]
  before_action :set_subject, only: [:create, :update]

  # GET /topics
  # GET /topics.json
  def index
    @subjects = Subject.only(:code).all

    if params[:commit] == "Search"
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
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @view_title = @topic.title
    @box_has_cards = [@topic.cards.where(box: 1).count() > 0 ? true : false, @topic.cards.where(box: 2).count() > 0 ? true : false, @topic.cards.where(box: 3).count() > 0 ? true : false]
  end

  # GET /topics/new
  def new
    @view_title = "New topic"
    @configs = ReviewConfiguration.all
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
    @view_title = "Editing topic"
    @configs = ReviewConfiguration.where(:name.ne => @topic.review_configuration)
  end

  # POST /topics
  def create
    @topic = Topic.new(topic_params)
    @topic.subject = @subject
    @topic.review_configuration = params[:review_configuration]
    
    respond_to do |format|
      if @topic.save
        Topic.set_review_boxes @topic
        Topic.set_review_dates @topic
        format.html { redirect_to @topic }
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
        @topic.subject = @subject
        if @topic.review_configuration != params[:review_configuration]
          @topic.update(review_configuration: params[:review_configuration])
          Topic.set_review_dates @topic
        end

        format.html { redirect_to @topic }
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
      format.html { redirect_to today_study_path }
      format.json { head :no_content }
    end
  end

  # PATCH /topics/:id/set_reviewing
  def set_reviewing
    respond_to do |format|
      @topic.reviewing ? @topic.update(reviewing: false) : @topic.update(reviewing: true)

      format.html { redirect_to @topic }
    end
  end

  # PATCH /topics/:id/reset_cards
  def reset_cards
    Topic.reset_cards @topic

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
      params[:id] ? @subject = Topic.find(params[:id]).subject : @subject = nil

      @subject ? @subjects = Subject.where(:_id.ne => @subject._id, :archived => false) : @subjects = Subject.not_archived
    end

    # Pack errors in a variable to be shown in the form
    def set_errors
      @errors = params[:errors] if params[:errors]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :review_configuration, :subject)
    end
end
