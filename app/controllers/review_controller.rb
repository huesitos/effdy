# ReviewController
class ReviewController < ApplicationController
  before_action :set_topic, except: [:study_calendar]
  before_action :set_card, only: [:front, :back, :answer]
  before_action :authenticate_user!

  # GET /study_calendar
  def study_calendar
    @view_title = "Study calendar"
    @study_topics = Topic.topics_to_study(session[:user_uname], DateTime.now)
  end

  # GET topics/:topic_id/review_box/:b
  # Picks a card and redirects to the front side.
  def review
    respond_to do |format|
      if @topic.cards.where(:review_date => {"$lte": DateTime.now}).count > 0
        # Retrieve next card to study
        card_id = Card.where(:review_date => {"$lte": DateTime.now})[0]

        if card_id
          @card = Card.find(card_id)
          format.html { redirect_to topic_card_front_path(card_id: @card._id) }
        else 
          format.html { 
            flash[:success] = "Review finished successfully."
            redirect_to @topic 
          }
        end
      else
        format.html { 
          redirect_to topic_path(@topic), 
          notice: "Topic has no cards to study." }
      end
  	end
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/front/
  # Shows the front side of the card.
  def front
    @view_title = "#{@topic.title}"
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/back/
  # Shows the back side of the card.
  def back
    @view_title = "#{@topic.title}"
    @u_answer = params[:u_answer]
  end

  # POST topics/:topic_id/review_box/:b/card/:card_id/answer
  # Answers the card and updates the review date if the review_date is today.
  def answer
    if params[:commit] == "Correct"
      Card.correct @card 
    else 
      Card.reset @card 
    end

    Card.update_review_date @card

    respond_to do |format|
  		format.html { redirect_to topic_review_path(@topic) }
  	end
  end

  private
    # Sets topic from param
    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    # Sets card from param
    def set_card
	  	@card = @topic.cards.find(params[:card_id])
    end
end
