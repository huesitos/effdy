FactoryGirl.define do

	factory :card_statistic do
		times_correct 0
		times_incorrect 0
		time_answering 60 #secs
		level 1
		review_date Date.today
		user
		card
	end

	factory :cs_level_five, class: CardStatistic do
		times_correct 4
		times_incorrect 0
		time_answering 60 #secs
		level 5
		review_date Date.today
		card
		user
	end
end