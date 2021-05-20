require_relative 'lib/view'
require_relative 'db/db'

DB.connect
View.bem_vindo
DB.close
