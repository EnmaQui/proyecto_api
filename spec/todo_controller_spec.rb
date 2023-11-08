require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #categoria" do
    it "returns a successful response" do
      get :categoria, params: { id_gen: 28 } # Reemplaza 28 con un ID de género válido
      expect(response).to have_http_status(:success)
    end

    it "assigns @movie_details" do
      get :categoria, params: { id_gen: 28 } # Reemplaza 28 con un ID de género válido
      expect(assigns(:movie_details)).not_to be_nil
    end
  end
end
