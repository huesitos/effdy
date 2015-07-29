require 'rails_helper'

RSpec.describe Topic, type: :model do
  fit "from_user retrieves topics that belong to a user" do
  	user = create(:user)
  	user2 = create(:user)

  	3.times { create(:topic, user: user) }
  	10.times { create(:topic, user: user2) }

  	from_user1 = Topic.from_user(user.id)
  	from_user2 = Topic.from_user(user2.id)

  	expect(from_user1.count).to eq 3.0
  	expect(from_user2.count).to eq 10.0
  end
end
