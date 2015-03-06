class CardsController < ApplicationController
  before_action :set_topic, only: [:new, :edit, :index]
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    if params[:box]
      @cards = Card.where(topic_id: params[:topic_id], box: params[:box].to_i)
    else
      @cards = Card.where(topic_id: params[:topic_id])
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
    @url = topic_cards_path(@topic._id)
    if params[:errors]
      @errors = params[:errors]
    end
  end

  # GET /cards/1/edit
  def edit
    @url = topic_card_path(@topic._id, @card._id)
    if params[:errors]
      @errors = params[:errors]
    end
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)
    @card.box = 3
    @card.topic = Topic.find(params[:topic_id])

    respond_to do |format|
      if @card.save
        format.html { redirect_to new_topic_card_path(@card.topic) }
      else
        format.html { redirect_to new_topic_card_path(@card.topic, errors: @card.errors.full_messages.each.to_a)}
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to topic_cards_path(@card.topic), notice: 'Card was successfully updated.' }
        # format.json { render :show, status: :ok, location: @card }
      else
        format.html { redirect_to edit_topic_card_path(@card.topic_id, @card._id, errors: @card.errors.full_messages.each.to_a) }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    topic = @card.topic
    @card.destroy
    respond_to do |format|
      format.html { redirect_to topic_cards_path(topic), notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      if params[:id]
        @card = Card.find(params[:id])
      else
        @card = Card.find(params[:card_id])
      end
    end

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:question, :answer)
    end
end
