# spec/rails_helper.rb

# Asegúrate de requerir Bundler y que se ejecute `Bundler.require`
require 'bundler'
Bundler.require

# Configura Rails de manera que use el entorno de prueba
ENV['RAILS_ENV'] ||= 'test'


# Requiere las bibliotecas de RSpec
require 'rspec/rails'

# Más configuración de RSpec si es necesario...

# Configuración adicional, como las bases de datos de prueba
RSpec.configure do |config|
  # Configura la base de datos
  config.use_transactional_fixtures = true

  # Otras configuraciones de RSpec si es necesario...
end
