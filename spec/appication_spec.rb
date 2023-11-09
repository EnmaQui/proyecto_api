require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #homepage" do
    it "return http success" do
      get :homepage
      expect(response).to have_http_status(:success)
    end
  end
end
require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #homepage" do
    it "renders the 'homepage' template" do
      get :homepage
      expect(response).to render_template("homepage")
    end
  end
end
