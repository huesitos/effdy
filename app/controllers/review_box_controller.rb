class ReviewBoxController < ApplicationController
  before_action :set_topic, except: [:today_study]
  before_action :set_card, only: [:front, :back, :answer]

  def today_study
    @box_reviews = BoxReview.where(review_date: Date.today.to_s)
  end

  # GET	topics/:topic_id/review_box/:b
  def review_box
  	respond_to do |format|
      # if params[:review]
      # if there is a box_review assigned for that box, change date
      review = BoxReview.where(topic_id: @topic._id, box: params[:b])[0]
      if review
        if params[:b] == 1
          date = Date.today + 1
          review.review_date = date.to_s
        elsif params[:b] == 2
          date = Date.today + 3
          review.review_date = date.to_s
        else
          date = Date.today + 7
          review.review_date = date.to_s
        end
        review.save
      end

  		# reset the cards to review them again
  		if params[:reset]
		  	@topic.cards.where(:box => params[:b], :reviewed => true).update_all(:reviewed => false)
  		end

  	  @card = @topic.cards.where(:box => params[:b], :reviewed.ne => true)[0]
  	  if @card
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
  		@card.reviewed = true
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
