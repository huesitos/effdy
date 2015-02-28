class ReviewBoxController < ApplicationController
  before_action :set_topic
  before_action :set_card, only: [:front, :back, :answer]

  # GET	topics/:topic_id/review_box/:n
  def review_box
  	respond_to do |format|
  		# reset the cards to review them again
  		if params[:reset]
		  	@topic.cards.where(:box => params[:n], :reviewed => true).update_all(:reviewed => false)
  		end

  	  @card = @topic.cards.where(:box => params[:n], :reviewed.ne => true)[0]
  	  if @card
	  	  format.html { redirect_to topic_card_front_path(card_id: @card._id) }
  	  else
  	  	format.html { redirect_to @topic, notice: "Finished reviewing box #{@box}" }
  	  end
  	end
  end

  # GET topics/:topic_id/review_box/:n/card/:card_id/front/
  def front
  end

  # GET topics/:topic_id/review_box/:n/card/:card_id/back/
  def back
  	@u_answer = params[:u_answer]
  end

  # POST topics/:topic_id/review_box/:n/card/:card_id/answer
  def answer
  	respond_to do |format|
  		if params[:commit] == "Correct"
  			@card.box = @card.box + 1 <= 3 ? @card.box + 1 : @card.box
  		else
  			@card.box = 1
  		end
  		@card.reviewed = true
  		@card.save
  		format.html {redirect_to topic_review_box_path(@topic, params[:n])}
  	end
  end

  private
    def set_topic
    	@topic = Topic.find(params[:topic_id])
    end

    def set_card
	  	@card = @topic.cards.find(params[:card_id])
	  	@box = params[:n]
    end
end
