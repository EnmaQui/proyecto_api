class TodoController < ApplicationController
  
  include Kaminari::PageScopeMethods
  before_action :comun
  require 'json'
  require 'rest-client'

  def categoria
    id_genero = params[:id_gen]
    api_key = '7752de1a342e0930da1c72487148b06b'
    @link_img = 'https://image.tmdb.org/t/p/w500'
  
    # Inicializamos un array vacío para almacenar las películas
    @movie_details = []
  
    page_number = 1
    max_pages = 10
  
    while page_number <= max_pages
      url = URI.parse("https://api.themoviedb.org/3/discover/movie?api_key=#{api_key}&language=es-ES&with_genres=#{id_genero}&page=#{page_number}")
  
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == 'https'
  
      request = Net::HTTP::Get.new(url.request_uri)
      response = http.request(request)
  
      if response.code == '200'
        movies = JSON.parse(response.body)['results']
        break if movies.empty? # Si no hay más resultados, salimos del bucle
        @movie_details.concat(movies)
      else
        @error_message = "Error: #{response.code}"
        break
      end
  
      page_number += 1
    end
  
    # Paginamos los resultados
    @movie_details = Kaminari.paginate_array(@movie_details).page(params[:page]).per(20)
  end
  def homepage
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


  def index
    api_key = '7752de1a342e0930da1c72487148b06b'
    url = URI.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=#{api_key}")
    @link_img='https://image.tmdb.org/t/p/w500'
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
  
    if response.code == '200'
      movies = JSON.parse(response.body)['results']
      @nuevas = Kaminari.paginate_array(movies).page(params[:page]).per(10) # Pagina los resultados, 10 por página
    else
      @error_message = "Error: #{response.code}"
    end
  end
  

  
  

  def resultado
    api_key = '7752de1a342e0930da1c72487148b06b'
    @link_img = 'https://image.tmdb.org/t/p/w500'
    query_i = params[:query]
    peli = query_i.to_s.gsub(/\s/, '%20')
  
    url = URI.parse("https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&query=#{peli}&include_adult=true&language=es-ES&page=1")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
  
    if response.code == '200'
      @info = JSON.parse(response.body)['results']
    else
      @error_message = "Error: #{response.code}"
    end
  
    respond_to do |format|
      format.html { render 'resultado' } # Renderizar la vista HTML
      format.js   # Renderizar la vista JS (si se usa AJAX)
    end
  end
  

  def enlistar
    user_id = params[:user_id]
    pelicula_id = params[:pelicula]

    # Hacer algo con user_id y pelicula_id
    # Por ejemplo, crear un nuevo registro en la tabla Lista

    @lista = Listum.new(user_id: user_id, pelicula: pelicula_id)

    if @lista.save
      # Éxito: haz algo después de guardar en la base de datos
      redirect_to index_path, notice: 'Película enlistada exitosamente.'
      
    else
      # Manejo de errores: algo salió mal al guardar
      redirect_to index_path, notice: 'No se a enlistado'
    end
  end


  def lista
    @listas = Listum.all
  
    api_key = '7752de1a342e0930da1c72487148b06b'
    
    # Asumiendo que quieres obtener la película para cada elemento en @listas
    @listas.each do |lista|
      movie_id = lista.pelicula
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
    end
  end
end
