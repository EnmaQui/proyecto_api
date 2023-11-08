# spec/spec_helper.rb

# Requiere RSpec y sus extensiones
require 'rspec'
require 'rspec/autorun'

# Configuración adicional de RSpec si es necesario...

# Carga los archivos de soporte (support) si los tienes
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Más configuraciones específicas si es necesario...
