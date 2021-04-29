# frozen_string_literal: true

require 'faraday'
require 'json'
require 'active_record'

class Municipio < ActiveRecord::Base
  def nomes_populares(codigo)
    resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
    resposta_json = JSON.parse(resposta.body, symbolize_names: true)
    resposta_json[0][:res]
  end
end
