require 'active_record'
require 'pg'

class DB
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      database: 'ibge',
      username: 'localuser',
      password: '1234',
      host: 'localhost',
      port: 5432
    )
  end

  def self.close
    ActiveRecord::Base.connection.close
  end
end
