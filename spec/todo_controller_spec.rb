require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #categoria" do
    it "returns a successful response" do
      get :categoria, params: { id_gen: 28 } # Reemplaza 28 con un ID de género válido
      expect(response).to have_http_status(:success)
    end
  end
end

require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #categoria" do
    it "assigns @movie_details" do
      get :categoria, params: { id_gen: 28 } # Reemplaza 28 con un ID de género válido
      expect(assigns(:movie_details)).not_to be_nil
    end
  end
end

require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #categoria" do
    it "paginates the results" do
      # Supongamos que tienes al menos 21 resultados, para que se pueda paginar
      get :categoria, params: { id_gen: 28, page: 2 } # Reemplaza 28 con un ID de género válido
      paginated_movies = assigns(:movie_details)
      expect(paginated_movies.current_page).to eq(2)
      expect(paginated_movies.total_pages).to be >= 2
      expect(paginated_movies.limit_value).to eq(20)
      expect(paginated_movies.total_count).to be >= 40
    end
  end
end
