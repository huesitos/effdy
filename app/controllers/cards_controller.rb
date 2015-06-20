# CardsController
class CardsController < ApplicationController
  before_action :set_topic, except: [:show, :destroy]
  before_action :set_errors, only: [:new, :edit]
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

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
    user = User.find_by(username: session[:user_uname])
    @topics = Topic.not_archived.where(:user_id => user._id, :_id.ne => @card.topic_id)
    @url = topic_card_path(@topic._id, @card._id) # url the form will use to send the values of the form
  end

  # POST /cards
  # POST /cards.json
  # Creates a new card with the topic in the params, and in box 1. If
  # the commit is 'Done' it redirects to the topics cards path. If not
  # it returns to a new topic card path.
  def create
    @card = Card.new(card_params)
    @card.topic = @topic
    @card.user = @topic.user

    respond_to do |format|
      if @card.save
        @card.create_card_statistic()
        flash[:success] = 'Card created successfully.'

        if params[:commit] == 'Done'
          format.html { redirect_to topic_path(@card.topic) }
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
      @card.topic = Topic.find(params[:new_topic])
      if @card.update(card_params)
        @card.save
        format.html {
          flash[:success] = 'Card updated successfully.'

          redirect_to topic_cards_path(@topic)
        }
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
      format.html {
        flash[:success] = 'Card deleted successfully.'

        redirect_to topic_path(topic)
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      params[:id] ? @card = Card.find(params[:id]) : @card = Card.find(params[:card_id])
    end

    # Get the current topic
    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    # Pack errors in a variable to be shown in the form
    def set_errors
      @errors = params[:errors] if params[:errors]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:front, :back)
    end
end
