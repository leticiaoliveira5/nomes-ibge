# frozen_string_literal: true

require 'active_record'

class UnidadeFederativa < ActiveRecord::Base
  has_many :municipios

  def nomes_populares
    resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
    json_resposta = JSON.parse(resposta.body, symbolize_names: true)
    json_resposta[0][:res]
  end
end
