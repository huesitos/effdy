require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #settings" do
    it "returns http success" do
      get :settings
      expect(response).to have_http_status(:success)
    end
  end

end
