FactoryGirl.define do
	
  factory :topic_config do
    archived false
    reviewing false
    recall_percentage 0.80
    user
  end
end
