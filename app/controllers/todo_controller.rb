class TodoController < ApplicationController
  require 'json'
  require 'rest-client'

  def index
    
    #movie_id = params[:id]  # El ID de la película lo obtienes desde la URL
    api_key = '7752de1a342e0930da1c72487148b06b'  # Reemplaza con tu clave de API de TMDb

    url = URI.parse("https://api.themoviedb.org/3/movie/popular?api_key=#{api_key}")
    @link_img='https://image.tmdb.org/t/p/w500'
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'
    
    request = Net::HTTP::Get.new(url.request_uri)
    
    response = http.request(request)
    
    if response.code == '200'
      @movie_details = JSON.parse(response.body)['results']
    else
      @error_message = "Error: #{response.code}"
    end
  end
end
