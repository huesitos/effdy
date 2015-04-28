require 'rails_helper'

RSpec.describe MenuController, type: :controller do

  describe "GET #menu" do
    it "returns http success" do
      get :menu
      expect(response).to have_http_status(:success)
    end
  end

end
