require_relative './lib/municipio'
require_relative './lib/unidade_federativa'

ufs = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
ufs_json = JSON.parse(ufs.body, symbolize_names: true)
ufs_json.each do |obj| 
  UnidadeFederativa.create(obj[:sigla], obj[:nome], obj[:id])
end

municipios = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios')
municipios_json = JSON.parse(municipios.body)
municipios_json.each do |obj|
  Municipio.create(obj['nome'], obj['id'], obj['regiao-imediata']['regiao-intermediaria']['UF']['sigla'])
end
