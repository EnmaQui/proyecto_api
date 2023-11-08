class TodoController < ApplicationController
  
  include Kaminari::PageScopeMethods
  before_action :comun
  before_action :require_login, only: [:lista]
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
    


    if user_signed_in?
      @esta_en_lista = current_user.listums.exists?(pelicula: movie_id)
    else
      @esta_en_lista = false
      # O muestra un mensaje de error, según lo que quieras hacer.
    end
    
  end
  


  def index
    api_key = '7752de1a342e0930da1c72487148b06b'
    url = URI.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=#{api_key}&language=es-ES")
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
    accion = params[:accion] # Nuevo parámetro para indicar si se va a enlistar o quitar
  
    if accion == 'quitar'
      # Código para quitar la película de la lista
      lista = Listum.find_by(user_id: user_id, pelicula: pelicula_id)
      if lista
        lista.destroy
        flash[:success] = "Película quitada de la lista."
      else
        flash[:error] = "La película no estaba en la lista."
      end
    elsif accion == 'enlistar'
      # Código para enlistar la película
      @lista = Listum.new(user_id: user_id, pelicula: pelicula_id)
  
      if @lista.save
        flash[:success] = "Película enlistada exitosamente."
      else
        flash[:error] = "No se pudo enlistar la película."
      end
    end
  
    redirect_to root_path
  end
  
  

  def lista
    require_login
  
    api_key = '7752de1a342e0930da1c72487148b06b'
    @link_img = 'https://image.tmdb.org/t/p/w500'

    
    @info = []
  
    @listas = current_user.listums # Obtener las listas asociadas al usuario actual
  
    @listas.each do |lista|
      movie_id = lista.pelicula
  
      url = URI.parse("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{api_key}&language=es-ES")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == 'https'
      request = Net::HTTP::Get.new(url.request_uri)
      response = http.request(request)
  
      if response.code == '200'
        @info << JSON.parse(response.body)
      else
        @error_message = "Error: #{response.code}"
      end
    end
  end
  
  def require_login
    unless current_user
      redirect_to new_user_session_path, notice: 'Por favor inicia sesión para acceder a esta página.'
    end

    query_i = params[:query]
    peli=query_i.to_s.gsub(/\s/, '%20')
  
    # Obtener información de la película
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


  end

  def eliminar_pelicula_lista
    require_login
  
    pelicula_id = params[:id]
  
    # Encuentra y elimina la lista asociada al usuario actual y a la película seleccionada
    lista = current_user.listums.find_by(pelicula: pelicula_id)
    if lista
      lista.destroy
      flash[:success] = "Película eliminada de la lista."
    else
      flash[:error] = "La película no estaba en la lista."
    end
  
    redirect_to lista_path
  end
  
  
end
