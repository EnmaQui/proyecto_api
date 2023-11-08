require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "displays movie details when @movie_details is present" do
      movie_details = [ { 'title' => 'Movie 1', 'vote_average' => 8.5, 'poster_path' => '/movie1.jpg' },
                       { 'title' => 'Movie 2', 'vote_average' => 7.9, 'poster_path' => '/movie2.jpg' } ]

      assign(:movie_details, movie_details)
      assign(:error_message, nil) # Assuming @error_message is nil when @movie_details is present

      get :index

      movie_details.each do |movie|
        expect(response.body).to have_selector("h5.card-title", text: movie['title'].upcase)
        expect(response.body).to have_selector("p.card-text", text: "#{movie['vote_average'].truncate}/10")
      end
    end

    it "displays error message when @error_message is present" do
      error_message = "An error occurred" # Replace with your error message

      assign(:error_message, error_message)
      assign(:movie_details, nil) # Assuming @movie_details is nil when @error_message is present

      get :index

      expect(response.body).to have_selector("p", text: error_message)
    end
  end
end
