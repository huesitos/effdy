class ReviewBoxController < ApplicationController
  before_action :set_topic, except: [:today_study]
  before_action :set_card, only: [:front, :back, :answer]

  def today_study
    @view_title = "Today study"
    topics = Topic.where(reviewing: true)
    @box_reviews = []
    topics.each do |topic|
      if topic.cards.count > 0
        topic.box_reviews.each do |box_review|
          @box_reviews << box_review if box_review.review_date <= Date.today.to_s
        end
      end
    end
  end

  def set_review
    # reset the cards to review them again
    box_review = @topic.box_reviews.find_by(box: params[:b])
    box_review.cards = []

    cards = @topic.cards.where(box: params[:b])
    cards.each do |card|
      box_review.cards.push(card._id)
    end
    box_review.cards.shuffle!
    config = DefaultConfiguration.find_by(name: @topic.review_configuration)

    if box_review.review_date <= Date.today.to_s
      if box_review.box == 1
        box_review.review_date = (Date.today + config.box1_frequency.day).to_s
      elsif box_review.box == 2
        box_review.review_date = (Date.today + config.box2_frequency.days).to_s
      else
        box_review.review_date = (Date.today + config.box3_frequency.days).to_s 
      end
    end
    box_review.save

    respond_to do |format|
      format.html {redirect_to topic_review_box_path(@topic, params[:b])}
    end
  end

  # GET	topics/:topic_id/review_box/:b
  def review_box
  	respond_to do |format|
      # if today is the assigned review date, change date
      box_review = @topic.box_reviews.find_by(box: params[:b])

      # Get a card from the box_review
  	  card_id = box_review.cards.pop()
      box_review.save

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
