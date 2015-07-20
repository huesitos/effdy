FactoryGirl.define do

  factory :user do
    sequence(:username) { |n| "aplus-user-#{n}" }
    sequence(:name) { |n| "John Doe ##{n}" }
    image 'http://pbs.twimg.com/profile_images/2437172008/62jzehzum66dhmdwslfu_normal.jpeg'
    provider { 'facebook' }
    uid { SecureRandom.hex }
    locale 'en'
    first_time false
  end
end
