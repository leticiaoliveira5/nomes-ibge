require 'faraday'
require 'json'

API_NOMES_URL = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/'.freeze
API_LOCALIDADES_URL = 'https://servicodados.ibge.gov.br/api/v1/localidades/'.freeze

class Api
  def self.nomes(input_nome)
    response = Faraday.get(API_NOMES_URL + input_nome)
    parser(response)
  end

  def self.localidades(tipo)
    response = Faraday.get(API_LOCALIDADES_URL + tipo)
    parser(response)
  end

  def self.ranking_nomes(sexo, codigo_localidade)
    nomes("ranking?sexo=#{sexo}&localidade=#{codigo_localidade}")
  end

  def self.estados
    localidades('estados')
  end

  def self.municipios
    localidades('municipios')
  end

  def self.parser(response)
    return [] if response.nil? || response.status == 400

    JSON.parse(response.body, symbolize_names: true)
  end
end
