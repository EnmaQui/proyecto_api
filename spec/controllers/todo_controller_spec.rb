# spec/controllers/tmdb_controller_spec.rb

require 'rails_helper'

RSpec.describe TmdbController, type: :controller do
  describe '#resultado' do
    context 'cuando la solicitud es exitosa' do
      before do
        allow(Net::HTTP).to receive(:new).and_return(http_double)
        allow(http_double).to receive(:request).and_return(successful_response)
      end
      
      let(:http_double) { instance_double(Net::HTTP) }
      let(:successful_response) { instance_double(Net::HTTPResponse, code: '200', body: '{"results": [{"title": "Movie 1"}, {"title": "Movie 2"}]}' ) }

      it 'asigna la información de las películas a @info' do
        get :resultado, params: { query: 'terminator' }
        expect(assigns(:info)).to eq([{"title"=>"Movie 1"}, {"title"=>"Movie 2"}])
      end

      it 'asigna la URL de la imagen a @link_img' do
        get :resultado, params: { query: 'terminator' }
        expect(assigns(:link_img)).to eq('https://image.tmdb.org/t/p/w500')
      end
    end

    context 'cuando la solicitud falla' do
      before do
        allow(Net::HTTP).to receive(:new).and_return(http_double)
        allow(http_double).to receive(:request).and_return(failed_response)
      end
      
      let(:http_double) { instance_double(Net::HTTP) }
      let(:failed_response) { instance_double(Net::HTTPResponse, code: '404') }

      it 'asigna un mensaje de error a @error_message' do
        get :resultado, params: { query: 'terminator' }
        expect(assigns(:error_message)).to eq('Error: 404')
      end
    end
  end
end
