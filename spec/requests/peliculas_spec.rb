require 'rails_helper'

RSpec.describe PeliculasController, type: :controller do
  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "assigns @movie_details" do
      movie_details = [] # Simula los datos que esperas en @movie_details
      get :index
      expect(assigns(:movie_details)).to eq(movie_details)
    end

    it "assigns @error_message when there's an error" do
      error_message = "An error message" # Simula un mensaje de error
      allow_any_instance_of(PeliculasController).to receive(:fetch_movie_details).and_return(error_message)
      get :index
      expect(assigns(:error_message)).to eq(error_message)
    end
  end
end
