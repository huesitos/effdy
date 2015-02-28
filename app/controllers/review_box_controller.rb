class ReviewBoxController < ApplicationController
  before_action :set_topic
  before_action :set_card, only: [:front, :back, :answer]

  def review_box
  	respond_to do |format|
  	  @card = @topic.cards.where(box: params[:n]).where.not('reviewed != ?', Date.today)
  	  format.html { redirect_to topic_card_front_path(card_id: @card._id) }
  	end
  end

  def front
  	@box = params[:n]
  end

  def back
  	@box = params[:n]
  	@u_answer = params[:u_answer]
  end

  def answer
  	respond_to do |format|
  		if params[:commit] == "Correct"
  			@card.box = @card.box + 1 <= 3 ? @card.box + 1 : @card.box
  		else
  			@card.box = 1
  		end
  		@card.reviewed = Date.today
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
    end
end
