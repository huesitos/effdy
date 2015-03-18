class CardsController < ApplicationController
  before_action :set_topic, except: [:show, :update, :destroy]
  before_action :set_error, only: [:new, :edit]
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    @view_title = @topic.title

    # If a specific box is picked, send back only the cards in that box
    if params[:box]
      @cards = Card.where(topic_id: @topic._id, box: params[:box].to_i)
      @box = params[:box].to_i # the number of the box that will have the active class
    else
      @cards = Card.where(topic_id: @topic._id)
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  # Not being used. Should test on test users to see if it's necessary
  def show
    @view_title = "Showing card"
  end

  # GET /cards/new
  def new
    @view_title = @topic.title
    @card = Card.new
    @url = topic_cards_path(@topic._id) # url the form will use to send the values of the form
  end

  # GET /cards/1/edit
  def edit
    @view_title = "Editing card"
    @url = topic_card_path(@topic._id, @card._id) # url the form will use to send the values of the form
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)
    @card.box = 1
    @card.topic = @topic

    respond_to do |format|
      if @card.save
        if params[:commit] == 'Done'
          format.html { redirect_to topic_cards_path(@card.topic) }
        else
          format.html { redirect_to new_topic_card_path(@card.topic) }
        end
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
        format.html { redirect_to topic_cards_path(@card.topic) }
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
      format.html { redirect_to topic_cards_path(topic) }
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

    # Get the current topic
    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    # Pack errors in a variable to be shown in the form
    def set_error
      if params[:errors]
        @errors = params[:errors]
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:question, :answer)
    end
end
