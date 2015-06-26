# CardStatistic keeps a record of the times a card was answered correctly and
# incorrectly. Also, it saves how much time it takes to answer it each time in
# minutes.
class CardStatistic
  include Mongoid::Document
  field :times_correct, type: Integer, default: 0
  field :times_incorrect, type: Integer, default: 0
  field :time_answering, type: Integer, default: 60 #secs

  embedded_in :card

  # Returns the approximate time it takes to answer the card in 
  # minutes
  def approx_time_to_answer
    d = self.times_correct + self.times_incorrect
    if d > 0
      (self.time_answering / d) / 60
    else
      (self.time_answering) / 60
    end
  end
end
