class TopicsController < ApplicationController
  before_action :set_topic, except: [:new, :index, :create]
  before_action :set_subjects, only: [:new, :edit]
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
    @configs = DefaultConfiguration.all
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
    @view_title = "Editing topic"
    @configs = DefaultConfiguration.where(:name.ne => @topic.review_configuration)
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)
    @topic.subject = @subject
    @topic.review_configuration = params[:review_configuration]
    config = DefaultConfiguration.find_by(name: @topic.review_configuration)


    respond_to do |format|
      if @topic.save
        @topic.box_reviews.create(box:1, review_date: Date.today)
        @topic.box_reviews.create(box:2, review_date: (Date.today + config.box2_frequency.days).to_s)
        @topic.box_reviews.create(box:3, review_date: (Date.today + config.box3_frequency.days).to_s)
        format.html { redirect_to @topic }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      @topic.subject = @subject
      if @topic.review_configuration != params[:review_configuration]
        @topic.review_configuration = params[:review_configuration]
        config = DefaultConfiguration.find_by(name: @topic.review_configuration)

        @topic.box_reviews.find_by(box:1).update(review_date: (Date.today +  config.box1_frequency.days).to_s)
        @topic.box_reviews.find_by(box:2).update(review_date: (Date.today + config.box2_frequency.days).to_s)
        @topic.box_reviews.find_by(box:3).update(review_date: (Date.today + config.box3_frequency.days).to_s)
      end

      if @topic.update(topic_params)
        format.html { redirect_to @topic }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end

  def set_reviewing
    respond_to do |format|
      if @topic.reviewing
        @topic.update(reviewing: false)

        format.html { redirect_to @topic }
      else
        @topic.update(reviewing: true)

        format.html { redirect_to @topic }
      end
    end
  end

  def reset_cards
    @topic.cards.each do |card|
      card.update(box: 1)
    end

    respond_to do |format|
      format.html { redirect_to @topic }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      if params[:id]
        @topic = Topic.find(params[:id])
      else
        @topic = Topic.find(params[:topic_id])
      end
    end

    # Set the subject specified by the param[:subject]
    def set_subject
      if params[:subject] != 'none'
        @subject = Subject.find(params[:subject_id])
      else
        @subject = nil
      end
    end

    # Search for all the subjects and the particular topic's subject, if exists
    def set_subjects
      if params[:id]
        @subject = Topic.find(params[:id]).subject
      else
        @subject = nil
      end
      if @subject
        @subjects = Subject.where(:_id.ne => @subject._id, :archived => false)
      else
        @subjects = Subject.where(:archived => false)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :review_configuration, :subject)
    end
end
