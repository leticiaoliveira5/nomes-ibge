require 'faraday'
require 'json'
require 'active_record'
require_relative 'db'
require_relative '../lib/unidade_federativa'
require_relative '../lib/municipio'

DB.connect
load 'db/schema.rb'

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
