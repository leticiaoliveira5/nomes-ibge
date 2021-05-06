require 'faraday'
require 'json'
require 'active_record'
require 'csv'
require_relative 'db'
require_relative '../lib/unidade_federativa'
require_relative '../lib/municipio'

DB.connect
load 'db/schema.rb'

# transforma arquivo csv em um array de hashes
csv_to_hash = CSV.parse(File.read('data/populacao_2019.csv'), headers: true).map(&:to_h)

ufs = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
ufs_json = JSON.parse(ufs.body, symbolize_names: true)
ufs_json.each do |obj|
  resultado = csv_to_hash.find { |hash| hash['Cód.'].to_i == obj[:id] }
  UnidadeFederativa.create(sigla: obj[:sigla],
                           nome: obj[:nome], codigo: obj[:id],
                           populacao: resultado['População Residente - 2019'].to_i)
end

municipios = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios')
municipios_json = JSON.parse(municipios.body)
municipios_json.each do |obj|
  res = csv_to_hash.find { |hash| hash['Cód.'].to_i == obj['id'] }
  Municipio.create(nome: obj['nome'], codigo: obj['id'],
                   unidade_federativa: obj['regiao-imediata']['regiao-intermediaria']['UF']['sigla'],
                   populacao: res['População Residente - 2019'].to_i)
end
