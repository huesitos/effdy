# ReviewController
class ReviewController < ApplicationController
  before_action :set_topic, except: [:study_calendar]
  before_action :set_card, only: [:front, :back, :answer]
  before_action :authenticate_user!

  # GET /study_calendar
  def study_calendar
    @view_title = "Review calendar"

    if params[:date]
      @date = DateTime.parse(params[:date])
    else
      @date = Date.today
    end

    @study_topics = Topic.topics_to_study(session[:user_id], @date)
  end

  # GET topics/:topic_id/review_box/:b
  # Picks a card and redirects to the front side.
  def review
    respond_to do |format|
      card_ids = CardStatistic.where(
        :review_date => {"$lte" => DateTime.now},
        :user_id => session[:user_id]).pluck(:card_id)
      cards = @topic.cards.where(:_id => { "$in" => card_ids.to_a })

      if cards.count > 0
        # Retrieve next card to study
        card_id = cards[0]

        @card = Card.find(card_id)
        format.html { redirect_to topic_card_front_path(card_id: @card._id) }
      else
        flash[:success] = "Review finished successfully."
        format.html { redirect_to topic_path(@topic) }
      end
  	end
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/front/
  # Shows the front side of the card.
  def front
    @view_title = "#{@topic.title}"
    @start_time = DateTime.now
  end

  # GET topics/:topic_id/review_box/:b/card/:card_id/back/
  # Shows the back side of the card.
  def back
    @view_title = "#{@topic.title}"
    @u_answer = params[:u_answer]
    end_time = DateTime.now
    start_time = DateTime.parse(params[:start_time])
    @difference = end_time.to_time - start_time.to_time
  end

  # POST topics/:topic_id/review_box/:b/card/:card_id/answer
  # Answers the card and updates the review date if the review_date is today.
  def answer
    time_answering = params[:difference].delete(',').to_i

    cs = CardStatistic.find_by(card_id: @card.id, user_id: session[:user_id])
    if params[:commit] == "Correct"
      cs.correct time_answering
    else 
      cs.incorrect time_answering
    end
    cs.update_review_date

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
