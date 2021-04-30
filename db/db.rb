require 'active_record'
require 'pg'

class DB
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      database: 'ibge',
      username: 'leticia5',
      password: '1234',
      host: 'localhost'
    )
  end

  def self.create_tables
    load 'db/schema.rb'
  end

  def self.close
    ActiveRecord::Base.connection.close
  end

  def self.seed
    load 'db/seed.rb'
  end
end
