# ReviewBoxController
class ReviewController < ApplicationController
  before_action :set_topic, except: [:study_calendar]
  before_action :set_card, only: [:front, :back, :answer]
  before_action :authenticate_user!

  # GET /study_calendar
  def study_calendar
    @view_title = "Study calendar"
    # user = User.find_by(username: session[:user_uname])
    # @review_boxes = ReviewBox.todays_study(user)
  end

  # GET	/topics/:topic_id/set_review
  # Before starting the box review, sets the cards of the review box
  # and updates the review date.
  def set_review
    # reset the cards to review them again
    review_box = @topic.review_boxes.find_by(box: params[:b])
    Review.set_cards review_box, params[:b]

    # update the review date of the box to be reviewed
    Review.update_date review_box

    respond_to do |format|
      format.html {redirect_to topic_review_box_path(@topic, params[:b])}
    end
  end

  # GET topics/:topic_id/review_box/:b
  # Picks a card and redirects to the front side.
  def review_box
  	respond_to do |format|
      review_box = @topic.review_boxes.find_by(box: params[:b])

      # Get a card from the review_box
  	  card_id = review_box.cards.pop()
      review_box.save

      if card_id
        @card = Card.find(card_id)
	  	  format.html { redirect_to topic_card_front_path(card_id: @card._id) }
  	  else
  	  	format.html { redirect_to @topic }
  	  end
  	end
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/front/
  # Shows the front side of the card.
  def front
    @view_title = "#{@topic.title} Box #{params[:b]}"
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/back/
  # Shows the back side of the card.
  def back
    @view_title = "#{@topic.title} Box #{params[:b]}"
    @u_answer = params[:u_answer]
  end

  # POST topics/:topic_id/review_box/:b/card/:card_id/answer
  # Moves the card to the next box if answered correctly or resets 
  # it to box 1.
  def answer
  	respond_to do |format|
      if params[:commit] == "Correct" then Card.correct @card else Card.reset @card end

  		format.html {redirect_to topic_review_box_path(@topic, params[:b])}
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
