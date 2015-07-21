require 'rails_helper'

RSpec.describe SessionController, type: :controller do

	context "when an a new user registers" do
		describe "with Twitter" do

			before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] }

			it do
				expect {
					get :create, provider: 'twitter'
				}.to change(User, :count).by(1)

				authenticated_user = assigns(:user)

				expect(response.status).to eql(302)
				expect(response).to redirect_to(study_calendar_path)
				expect(authenticated_user.provider).to eql('twitter')
				expect(authenticated_user.username).to eql('paulie')
				expect(authenticated_user.uid).to eql('123545')
			end

		end

		context "with other providers" do
			describe "with Facebook" do

				before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] }

				it do
					expect {
						get :create, provider: 'facebook'
					}.to change(User, :count).by(1)

					authenticated_user = assigns(:user)

					expect(response.status).to eql(302)
					expect(response).to redirect_to(study_calendar_path)
					expect(authenticated_user.provider).to eql('facebook')
					expect(authenticated_user.username).to eql('not.paul.smith')
					expect(authenticated_user.uid).to eql('1337')
				end
			end

			describe "with Google" do

				before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google] }

				it do
					expect {
						get :create, provider: 'google'
					}.to change(User, :count).by(1)

					authenticated_user = assigns(:user)

					expect(response.status).to eql(302)
					expect(response).to redirect_to(study_calendar_path)
					expect(authenticated_user.provider).to eql('google')
					expect(authenticated_user.username).to eql('google-user')
					expect(authenticated_user.uid).to eql('007')
				end
			end
		end
	end

	context "when an exisitng user returns" do

		describe "it should properly authenticate it" do
			let(:returning_user) { FactoryGirl.create(:user) }

			before do
				OmniAuth.config.add_mock(:facebook, { uid: returning_user.uid })
				request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
			end

			it do
				expect {
					get :create, provider: 'facebook'
				}.not_to change(User, :count)

				authenticated_user = assigns(:user)

				expect(response.status).to eql(302)
				expect(response).to redirect_to(study_calendar_path)
				expect(authenticated_user.uid).to eql(returning_user.uid)
			end
		end

	end
end
