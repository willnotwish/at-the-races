require 'rails_helper'

RSpec.describe "CounterUpdates", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/counter_updates/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/counter_updates/show"
      expect(response).to have_http_status(:success)
    end
  end

end
