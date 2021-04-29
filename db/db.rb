require 'active_record'
require 'pg'

class DB
  def self.connect
    # antes:
    # $db = PG.connect({ dbname: 'ibge', host: 'localhost', user: 'leticia5', password: '1234' })
    @db = ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      database: 'ibge',
      username: 'leticia5',
      password: '1234',
      host: 'localhost'
    )
  end

  def self.close
    @db&.close
  end

  def self.create_tables
    ActiveRecord::Schema.define do
      self.verbose = false

      enable_extension 'plpgsql'
      enable_extension 'pgcrypto'

      create_table(:unidade_federativas, force: true) do |t|
        t.string :sigla, null: false
        t.string :nome, null: false
        t.integer :codigo, null: false
      end

      create_table(:municipios, force: true) do |t|
        t.string :nome, null: false
        t.integer :codigo, null: false
        t.string :unidade_federativa, null: false
      end
    end
  end

  def self.seed
    ufs = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
    ufs_json = JSON.parse(ufs.body, symbolize_names: true)
    ufs_json.each do |obj|
      UnidadeFederativa.create!(sigla: obj[:sigla], nome: obj[:nome], codigo: obj[:id])
    end

    municipios = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios')
    municipios_json = JSON.parse(municipios.body)
    municipios_json.each do |obj|
      Municipio.create!(nome: obj['nome'], codigo: obj['id'],
                        unidade_federativa: obj['regiao-imediata']['regiao-intermediaria']['UF']['sigla'])
    end
  end
end
