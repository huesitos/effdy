class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy, :new_card]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @box_has_cards = []
    @box_has_cards[0] = @topic.cards.where(box: 1).count() > 0 ? true : false
    @box_has_cards[1] = @topic.cards.where(box: 2).count() > 0 ? true : false
    @box_has_cards[2] = @topic.cards.where(box: 3).count() > 0 ? true : false
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
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
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
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
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /topics/:topic_id/new_card
  def new_card
    @card = Card.new
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title)
    end
end
