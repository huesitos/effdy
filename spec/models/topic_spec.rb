require 'rails_helper'

RSpec.describe Topic, type: :model do
  it "from_user retrieves topics that belong to a user" do
  	user = create(:user)
  	user2 = create(:user)

  	3.times { create(:topic, user: user) }
  	10.times { create(:topic, user: user2) }

  	from_user1 = Topic.from_user(user.id)
  	from_user2 = Topic.from_user(user2.id)

  	expect(from_user1.count).to eq 3.0
  	expect(from_user2.count).to eq 10.0
  end

  fit "reset_cards moves all cards back to level 1" do
  	user = create(:user)
  	topic = create(:topic, user: user)

  	5.times { topic.cards << create(:card) }
  	expect(topic.cards.count).to eq 5

  	topic.cards.each do |card|
  		card.card_statistics << create(:cs_level_five, user: user)
  	end

  	topic.reset_cards(user.id)

  	topic.cards.each do |card|
  		card.card_statistics.each do |cs|
  			expect(cs.level).to eq 1
  		end
  	end
  end

  it "topics_to_study returns a list with all the topics that have cards that must be studied in a given date"
  it "cards_to_study returns all the cards that must be studied today for a user"
  it "share creates a copy of a topic and all its cards on the recipient user"
  it "add_collaborator adds a collaborator topic_config to the topic"
  it "remove_collaborator removes the topic_config of a collaborator"
end
