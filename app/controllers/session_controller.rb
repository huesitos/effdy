class SessionController < ApplicationController
  def create
    # find_or_create_from_hash method is defined in app/models/users.rb
    # the method finds an existing user, or creates a new one
    @user = User.find_or_create_from_auth_hash(auth_hash, I18n.locale)
    # current_user= method defined in app/controllers/application_controller.rb
    # the method sets the session variables
    self.current_user = @user

    I18n.locale = @user.locale

    if @user.first_time
      basics = @user.subjects.create(name: 'Basics', code: 'BASICS')
      basics.subject_configs.create(color: '#000', user_id: @user.id)

      review_topic = basics.topics.create(title: t('.review_title'), user_id: @user.id)
      review_topic.topic_configs.create(user_id: @user.id, reviewing: true)

      rcards = [
	{front: t('.rcard1_front'), back: t('.rcard1_back')},
	{front: t('.rcard2_front'), back: t('.rcard2_back')},
	{front: t('.rcard3_front'), back: t('.rcard3_back')},
	{front: t('.rcard4_front'), back: t('.rcard4_back')},
	{front: t('.rcard5_front'), back: t('.rcard5_back')}
      ]

      review_topic.cards.create(rcards)

      review_topic.cards.each do |card|
	card.card_statistics.create(user_id: @user.id)
      end

      navigation_topic = basics.topics.create(title: t('.navigation_title'), user_id: @user.id)
      navigation_topic.topic_configs.create(user_id: @user.id, reviewing: true)

      ncards = [
	{front: t('.ncard1_front'), back: t('.ncard1_back')},
	{front: t('.ncard2_front'), back: t('.ncard2_back')},
	{front: t('.ncard3_front'), back: t('.ncard3_back')},
	{front: t('.ncard4_front'), back: t('.ncard4_back')}
      ]

      navigation_topic.cards.create(ncards)

      navigation_topic.cards.each do |card|
	card.card_statistics.create(user_id: @user.id)
      end

      @user.update(first_time: false)
    end

    redirect_to study_calendar_path
  end

  def destroy
    reset_session

    # Go back to welcome page
    redirect_to login_url
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
