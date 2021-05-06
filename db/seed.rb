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
ufs_json.each do |item|
  resultado = csv_to_hash.find { |hash| hash['Cód.'].to_i == item[:id] }
  UnidadeFederativa.create(sigla: item[:sigla],
                           nome: item[:nome],
                           codigo: item[:id],
                           populacao: resultado['População Residente - 2019'].to_i)
end

municipios = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios')
municipios_json = JSON.parse(municipios.body, symbolize_names: true)
municipios_json.each do |item|
  res = csv_to_hash.find { |hash| hash['Cód.'].to_i == item[:id] }
  Municipio.create(nome: item[:nome],
                   codigo: item[:id],
                   sigla_uf: item[:microrregiao][:mesorregiao][:UF][:sigla],
                   unidade_federativa: UnidadeFederativa.find_by(sigla: item[:microrregiao][:mesorregiao][:UF][:sigla]),
                   populacao: res['População Residente - 2019'].to_i)
end
