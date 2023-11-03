class TodoController < ApplicationController
  require 'json'
  require 'rest-client'

  def index
    
    #movie_id = params[:id]  # El ID de la película lo obtienes desde la URL
    api_key = '7752de1a342e0930da1c72487148b06b'

    url = URI.parse("https://api.themoviedb.org/3/movie/popular?api_key=#{api_key}&language=es-ES")
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

  def descripcion
    api_key = '7752de1a342e0930da1c72487148b06b'
    movie_id = params[:parametro]
    @link_img = 'https://image.tmdb.org/t/p/w500'
    
    # Obtener información de la película
    url = URI.parse("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{api_key}&language=es-ES")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    
    if response.code == '200'
      @info = JSON.parse(response.body)
    else
      @error_message = "Error: #{response.code}"
    end
    
    # Obtener información de los videos
    url_img = URI.parse("https://api.themoviedb.org/3/movie/#{movie_id}/videos?api_key=#{api_key}")
    http = Net::HTTP.new(url_img.host, url_img.port)
    http.use_ssl = true if url_img.scheme == 'https'
    request = Net::HTTP::Get.new(url_img.request_uri)
    response = http.request(request)
    
    if response.code == '200'
      @info_videos = response.body  # No se necesita parsear, ya es un string JSON
    else
      @error_message = "Error: #{response.code}"
    end
  end
  
end
