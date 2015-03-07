class ReviewBoxController < ApplicationController
  before_action :set_topic, except: [:today_study]
  before_action :set_card, only: [:front, :back, :answer]

  def today_study
    @box_reviews = BoxReview.where(review_date: Date.today.to_s)
  end

  def set_review
    # reset the cards to review them again
    box_review = BoxReview.where(topic_id: @topic._id, box: params[:b])[0]
    box_review.cards = []

    cards = @topic.cards.where(box: params[:b])
    cards.each do |card|
      box_review.cards.push(card._id)
    end
    box_review.cards.shuffle!
    box_review.save

    respond_to do |format|
      format.html {redirect_to topic_review_box_path(@topic, params[:b])}
    end
  end

  # GET	topics/:topic_id/review_box/:b
  def review_box
  	respond_to do |format|
      # if today is the assigned review date, change date
      box_review = BoxReview.where(topic_id: @topic._id, box: params[:b])[0]
      if box_review.review_date == Date.today.to_s
        if params[:b].to_i == 1
          date = Date.today + 1.day
          box_review.review_date = date.to_s
        elsif params[:b].to_i == 2
          date = Date.today + 3.days
          box_review.review_date = date.to_s
        else
          date = Date.today + 7.days
          box_review.review_date = date.to_s
        end
        box_review.save
      end

      # Get a card from the box_review
  	  card_id = box_review.cards.pop()
      box_review.save

      if card_id
        @card = Card.find(card_id)
	  	  format.html { redirect_to topic_card_front_path(card_id: @card._id) }
  	  else
  	  	format.html { redirect_to @topic, notice: "Finished reviewing box #{@box}" }
  	  end
  	end
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/front/
  def front
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/back/
  def back
  	@u_answer = params[:u_answer]
  end

  # POST topics/:topic_id/review_box/:b/card/:card_id/answer
  def answer
  	respond_to do |format|
  		if params[:commit] == "Correct"
  			@card.box = @card.box + 1 <= 3 ? @card.box + 1 : @card.box
  		else
  			@card.box = 1
  		end
  		@card.save
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
