require 'rails_helper'

RSpec.describe "RaceResults", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/race_results/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/race_results/show"
      expect(response).to have_http_status(:success)
    end
  end

end
