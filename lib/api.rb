require 'faraday'
require 'json'

API_NOMES_URL = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/'.freeze
API_LOCALIDADES_URL = 'https://servicodados.ibge.gov.br/api/v1/localidades/'.freeze

class Api
  def self.nomes(url)
    response = Faraday.get(API_NOMES_URL + url)
    return [] if response.status == 400

    parser(response)
  end

  def self.localidades(url)
    response = Faraday.get(API_LOCALIDADES_URL + url)
    return [] if response.status == 400

    parser(response)
  end

  def self.parser(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
