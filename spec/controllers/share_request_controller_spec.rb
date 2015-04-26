require 'rails_helper'

RSpec.describe ShareRequestController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #share" do
    it "returns http success" do
      get :share
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #notify" do
    it "returns http success" do
      get :notify
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

end
