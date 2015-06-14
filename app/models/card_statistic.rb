# CardStatistic keeps a record of the times a card was answered correctly and
# incorrectly. Also, it saves how much time it takes to answer it each time in
# minutes.
class CardStatistic
  include Mongoid::Document
  field :times_correct, type: Integer, default: 0
  field :times_incorrect, type: Integer, default: 0
  field :time_answering, type: Integer, default: 2

  embedded_in :card

  # Returns the approximate time it takes to answer the card in 
  def self.approx_time_to_answer(card_statistic)
  	d = card_statistic.times_correct + card_statistic.times_incorrect
  	if d > 0
  		card_statistic.time_answering / d
  	else
  		card_statistic.time_answering
  	end
  end
end
