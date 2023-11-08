require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end

require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #index" do
    it "assigns @nuevas" do
      get :index
      expect(assigns(:nuevas)).not_to be_nil
    end
  end
end
