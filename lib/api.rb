require 'faraday'
require 'json'

API_NOMES_URL = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/'.freeze
API_LOCALIDADES_URL = 'https://servicodados.ibge.gov.br/api/v1/localidades/'.freeze

class Api
  def self.nomes(url)
    resp = Faraday.get(API_NOMES_URL + url)
    return [] if resp.status == 400

    JSON.parse(resp.body, symbolize_names: true)
  end

  def self.localidades(url)
    resp = Faraday.get(API_LOCALIDADES_URL + url)
    return [] if resp.status == 400

    JSON.parse(resp.body, symbolize_names: true)
  end
end
