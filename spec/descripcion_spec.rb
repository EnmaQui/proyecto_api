require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #descripcion" do
    it "returns a successful response" do
      get :descripcion, params: { parametro: '123' } # Reemplaza '123' con un ID de película válido
      expect(response).to have_http_status(:success)
    end
  end
end

require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #descripcion" do
    it "assigns @info" do
      get :descripcion, params: { parametro: '123' } # Reemplaza '123' con un ID de película válido
      expect(assigns(:info)).not_to be_nil
    end
  end
end

require 'rails_helper'

RSpec.describe TodoController, type: :controller do
  describe "GET #descripcion" do
    it "renders the 'descripcion' template" do
      get :descripcion, params: { parametro: '123' } # Reemplaza '123' con un ID de película válido
      expect(response).to render_template("descripcion")
    end
  end
end

