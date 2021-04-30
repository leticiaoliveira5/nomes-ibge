require 'faraday'
require 'json'
require 'active_record'
require 'smarter_csv'
require_relative 'db'
require_relative '../lib/unidade_federativa'
require_relative '../lib/municipio'

DB.connect
load 'db/schema.rb'

csv = SmarterCSV.process('data/populacao_2019.csv')

ufs = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
ufs_json = JSON.parse(ufs.body, symbolize_names: true)
ufs_json.each do |obj|
  resultado = csv.find { |hash| hash[:"cód."] == obj[:id] }
  UnidadeFederativa.create(sigla: obj[:sigla],
                           nome: obj[:nome], codigo: obj[:id],
                           populacao: resultado[:população_residente___2019])
end

municipios = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios')
municipios_json = JSON.parse(municipios.body)
municipios_json.each do |obj|
  res = csv.find { |hash| hash[:"cód."] == obj['id'] }
  Municipio.create(nome: obj['nome'], codigo: obj['id'],
                   unidade_federativa: obj['regiao-imediata']['regiao-intermediaria']['UF']['sigla'],
                   populacao: res[:população_residente___2019])
end
