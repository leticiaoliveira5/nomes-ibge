require 'pg'

class DB
  def self.connect
    $db = PG.connect({ dbname: 'ibge', host: 'localhost', password: '1234' })
  end

  def self.close
    $db&.close
  end
end
