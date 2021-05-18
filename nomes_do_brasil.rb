require_relative 'lib/names_app'
require_relative 'lib/view'
require_relative 'db/db'

DB.connect
View.bem_vindo
View.escolher_opcao
DB.close
