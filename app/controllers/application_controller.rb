class ApplicationController < ActionController::Base
    def comun
        api_key = '7752de1a342e0930da1c72487148b06b'
        url = URI.parse("https://api.themoviedb.org/3/genre/movie/list?api_key=#{api_key}&language=es")
        #url = URI.parse("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{api_key}&language=es-ES")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true if url.scheme == 'https'
        request = Net::HTTP::Get.new(url.request_uri)
        response = http.request(request)
        
        if response.code == '200'
            @generos = JSON.parse(response.body)
        else
            @error_message = "Error: #{response.code}"
        end
    
    end

end
