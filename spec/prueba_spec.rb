require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #homepage" do
    it "renders the 'homepage' template" do
      get :homepage
      expect(response).to render_template("homepage")
    end
  end
end
