class ReviewBoxController < ApplicationController
  before_action :set_topic, except: [:today_study]
  before_action :set_card, only: [:front, :back, :answer]

  def today_study
    @view_title = "Today study"
    
    @review_boxes = ReviewBox.today_study
  end

  def set_review
    # reset the cards to review them again
    review_box = @topic.review_boxes.find_by(box: params[:b])
    ReviewBox.set_cards review_box, params[:b]

    # update the review date of the box to be reviewed
    ReviewBox.update_date review_box

    respond_to do |format|
      format.html {redirect_to topic_review_box_path(@topic, params[:b])}
    end
  end

  # GET	topics/:topic_id/review_box/:b
  def review_box
  	respond_to do |format|
      review_box = @topic.review_boxes.find_by(box: params[:b])

      ReviewBox.set_cards review_box, params[:b]

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
  def front
    @view_title = "#{@topic.title} Box #{params[:b]}"
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/back/
  def back
    @view_title = "#{@topic.title} Box #{params[:b]}"
  	@u_answer = params[:u_answer]
  end

  # POST topics/:topic_id/review_box/:b/card/:card_id/answer
  def answer
  	respond_to do |format|
      if params[:commit] == "Correct" then Card.correct @card else Card.reset @card end

  		format.html {redirect_to topic_review_box_path(@topic, params[:b])}
  	end
  end

  private
    def set_topic
    	@topic = Topic.find(params[:topic_id])
    end

    def set_card
	  	@card = @topic.cards.find(params[:card_id])
    end
end
