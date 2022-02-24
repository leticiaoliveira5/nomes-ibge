require 'active_record'
require 'sqlite3'

class DB
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'db/development.sqlite3'
    )
  end

  def self.close
    ActiveRecord::Base.connection.close
  end
end
